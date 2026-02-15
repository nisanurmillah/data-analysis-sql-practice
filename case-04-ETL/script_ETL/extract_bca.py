import re
import pdfplumber
import csv

# --- Fungsi kategori ---
def categorize(description, counterparty, sub_keterangan):
    text = (description + " " + counterparty + " " + sub_keterangan).upper()

    # --- Tagihan spesifik ---
    if "PLN" in text:
        return "Tagihan:Listrik"
    if "PULSA" in text:
        return "Tagihan:Pulsa"
    if "INDIHOME" in text or "INTERNET" in text:
        return "Tagihan:Internet"

    # --- Gaji ---
    if "GAJI" in text or "PAYROLL" in text:
        return "Gaji"

    # --- FTFVA (Virtual Account) ---
    if "FTFVA" in text:
        if any(word in text for word in ["KREDI", "UKU", "EASYCASH", "FINTOPIA"]):
            return "Tagihan/Belanja:Pinjaman Online"
        if any(word in text for word in ["TOKOPEDIA", "SHOPEE", "LAZADA", "BUKALAPAK"]):
            return "Tagihan/Belanja:Belanja Online"
        if any(word in text for word in ["DANA", "OVO", "GOPAY"]):
            return "Tagihan/Belanja:Top-up Dompet Digital"
        return "Tagihan/Belanja:Umum"

    # --- Transfer ---
    if "BI-FAST" in text or "BIF TRANSFER" in text:
        return "Transfer:BI-Fast"
    if "SWITCHING" in text:
        return "Transfer:ATM/EDC/Virtual Account"
    if "TRSF E-BANKING" in text:
        return "Transfer:E-Banking"

    # --- BYR VIA (bayar tagihan umum) ---
    if "BYR VIA" in text:
        return "Tagihan:Umum"

    return "Lainnya"


# --- Fungsi deteksi channel ---
def detect_channel(description):
    text = description.upper()
    if "FTFVA" in text:
        return "Virtual Account"
    if "E-BANKING" in text:
        return "E-Banking"
    if "BI-FAST" in text:
        return "BI-Fast"
    if "SWITCHING" in text:
        return "Switching"
    if "M-BCA" in text:
        return "M-BCA"
    return "Lainnya"

# --- Fungsi normalisasi angka ---
def parse_amount(raw):
    if not raw:
        return None
    cleaned = re.sub(r"[^\d]", "", raw)  # buang titik/koma
    if not cleaned:
        return None
    if len(cleaned) > 2:
        value = float(cleaned[:-2] + "." + cleaned[-2:])
    else:
        value = float(cleaned)
    return value

# --- Format ke Rupiah (IDR) ---
def format_rupiah(value):
    if value is None:
        return ""
    return f"{value:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")

# --- Path file ---
input_pdf = r"c:\Users\DELL\Documents\belajar.py\input_pdf\rekening_bca_saepul_desember_2022.pdf"
output_csv = "mutasi_bca.csv"

transactions = []
no_rekening = ""
nama_rekening = ""
periode = ""

with pdfplumber.open(input_pdf) as pdf:
    for page in pdf.pages:
        text = page.extract_text()
        if not text:
            continue

        # Metadata rekening
        if "NO. REKENING" in text:
            m = re.search(r"NO\. REKENING\s*:\s*(\d+)", text)
            if m:
                no_rekening = m.group(1)
        if "PERIODE" in text:
            m = re.search(r"PERIODE\s*:(.*)", text)
            if m:
                periode = m.group(1).strip()
        if "INDONESIA" in text:
            lines = text.split("\n")
            for i, l in enumerate(lines):
                if "INDONESIA" in l and i > 0:
                    nama_rekening = lines[i-1].strip()

        lines = text.split("\n")
        for i, line in enumerate(lines):
            if re.match(r"\d{2}/\d{2}", line):
                tanggal = line.split()[0]
                keterangan = line[len(tanggal):].strip()

                reference_id = ""
                lokasi_cabang = ""
                counterparty = ""
                sub_keterangan = ""

                mutasi = 0
                jenis_mutasi = ""

                # Format DB → nominal sebelum DB
                m_db = re.search(r"([\d,.]+)\s+DB", line)
                if m_db:
                    mutasi = parse_amount(m_db.group(1))
                    jenis_mutasi = "DB"

                # Format CR tipe 1 → nominal setelah CR + kode transaksi
                m_cr1 = re.search(r"CR\s+\S+\s+([\d,.]+)", line)
                if m_cr1:
                    mutasi = parse_amount(m_cr1.group(1))
                    jenis_mutasi = "CR"

                # Format CR tipe 2 → nominal setelah DR
                m_cr2 = re.search(r"DR\s+([\d,.]+)", line)
                if m_cr2 and "CR" in line:
                    mutasi = parse_amount(m_cr2.group(1))
                    jenis_mutasi = "CR"

                pemasukan, pengeluaran = 0.0, 0.0
                if jenis_mutasi == "DB":
                    pengeluaran = mutasi
                elif jenis_mutasi == "CR":
                    pemasukan = mutasi

                # --- Ambil saldo ---
                saldo = None
                parts = line.split()
                if parts and re.match(r"^[\d,.\-]+$", parts[-1]):
                    saldo = parse_amount(parts[-1])
                else:
                    # cek di baris berikut kalau berupa angka
                    if i+1 < len(lines):
                        next_line = lines[i+1].strip()
                        if re.match(r"^[\d,.\-]+$", next_line):
                            saldo = parse_amount(next_line)

                # Counterparty & sub_keterangan
                if i+1 < len(lines):
                    next_line = lines[i+1].strip()
                    if next_line.startswith("TANGGAL :"):
                        parts2 = next_line.split()
                        if len(parts2) > 2:
                            possible = " ".join(parts2[2:])
                            if re.search(r"[A-Za-z]", possible):
                                counterparty = possible
                            else:
                                sub_keterangan = possible
                    elif not re.match(r"\d{2}/\d{2}", next_line):
                        if re.fullmatch(r"[0-9.,]+", next_line):
                            sub_keterangan = next_line
                            if i+2 < len(lines):
                                next_line2 = lines[i+2].strip()
                                if re.search(r"[A-Za-z]", next_line2):
                                    counterparty = next_line2
                        else:
                            counterparty = next_line

                if i+2 < len(lines):
                    next_line2 = lines[i+2].strip()
                    if not re.match(r"\d{2}/\d{2}", next_line2) and not next_line2.startswith("TANGGAL"):
                        if re.search(r"[A-Za-z]", next_line2):
                            sub_keterangan = next_line2

                # Reference ID
                m = re.search(r"(\d{2,}/[A-Z]+\w*/WS\d+)", line)
                if m:
                    reference_id = m.group(1)

                # Lokasi cabang
                if "M-BCA" in line or "EDC" in line:
                    lokasi_cabang = line.split()[-1]

                if counterparty in ["-", "--"]:
                    counterparty = ""

                kategori = categorize(keterangan, counterparty, sub_keterangan)
                channel = detect_channel(keterangan)

                transactions.append({
                    "tanggal": tanggal,
                    "reference_id": reference_id,
                    "keterangan": keterangan,
                    "sub_keterangan": sub_keterangan,
                    "counterparty": counterparty,
                    "jenis_mutasi": jenis_mutasi,
                    "pemasukan": format_rupiah(pemasukan) if pemasukan else "",
                    "pengeluaran": format_rupiah(pengeluaran) if pengeluaran else "",
                    "saldo": format_rupiah(saldo) if saldo else "",
                    "kategori": kategori,
                    "channel": channel,
                    "lokasi_cabang": lokasi_cabang,
                    "no_rekening": no_rekening,
                    "nama_rekening": nama_rekening,
                    "periode": periode
                })

# Simpan ke CSV
if transactions:
    with open(output_csv, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=transactions[0].keys())
        writer.writeheader()
        writer.writerows(transactions)

    print(f"Berhasil diekstrak {len(transactions)} transaksi ke {output_csv}")
else:
    print("Tidak ada transaksi yang berhasil diekstrak.")
