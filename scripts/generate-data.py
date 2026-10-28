"""Generates the fictional catalog + wholesale price list used by the demo."""
import json
import random
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "src" / "server" / "data"
rng = random.Random(42)

# id, sku, name, category, wholesale base (USD), stock, published, attributes
ROWS = [
    # --- processors
    ("cpu-r5-5600", "CPU-5600", "AMD Ryzen 5 5600 6-Core 3.5GHz", "cpu", 118, 14, True, {"socket": "AM4"}),
    ("cpu-r7-5700x", "CPU-5700X", "AMD Ryzen 7 5700X 8-Core 3.4GHz AM4", "cpu", 168, 9, True, {}),
    ("cpu-r5-7600", "CPU-7600", "AMD Ryzen 5 7600 6-Core 3.8GHz", "cpu", 176, 12, True, {"socket": "AM5"}),
    ("cpu-r7-7700x", "CPU-7700X", "AMD Ryzen 7 7700X 8-Core 4.5GHz AM5", "cpu", 262, 6, True, {}),
    ("cpu-i5-12400f", "CPU-12400F", "Intel Core i5-12400F 2.5GHz LGA1700", "cpu", 124, 20, True, {}),
    ("cpu-i5-13400f", "CPU-13400F", "Intel Core i5-13400F 2.5GHz LGA1700", "cpu", 172, 11, True, {"socket": "LGA1700"}),
    ("cpu-i7-14700k", "CPU-14700K", "Intel Core i7-14700K 3.4GHz LGA1700", "cpu", 349, 5, False, {}),
    ("cpu-ultra5-245k", "CPU-U5-245K", "Intel Core Ultra 5 245K 4.2GHz", "cpu", 281, 7, True, {}),
    ("cpu-i3-10100", "CPU-10100", "Intel Core i3-10100 3.6GHz LGA1200", "cpu", 82, 0, False, {}),
    # --- motherboards
    ("mb-b550m-a", "MB-B550M-A", "ASUS PRIME B550M-A AM4 DDR4", "motherboard", 89, 10, True, {"socket": "AM4", "ramType": "DDR4"}),
    ("mb-b450m-pro", "MB-B450M-PRO", "MSI B450M PRO-VDH MAX", "motherboard", 62, 8, True, {"ramType": "DDR4"}),
    ("mb-b650m-ds3h", "MB-B650M-DS3H", "Gigabyte B650M DS3H DDR5", "motherboard", 128, 9, True, {"socket": "AM5", "ramType": "DDR5"}),
    ("mb-x670e-pro", "MB-X670E-PRO", "ASRock X670E Pro RS", "motherboard", 214, 4, True, {"ramType": "DDR5"}),
    ("mb-b760m-d4", "MB-B760M-D4", "MSI PRO B760M-E DDR4", "motherboard", 104, 12, True, {"ramType": "DDR4"}),
    ("mb-b760m-d5", "MB-B760M-D5", "ASUS PRIME B760M-A WIFI DDR5", "motherboard", 139, 7, True, {"ramType": "DDR5"}),
    ("mb-z890-elite", "MB-Z890-ELITE", "Gigabyte Z890 AORUS Elite DDR5", "motherboard", 289, 3, False, {}),
    ("mb-h510m", "MB-H510M", "MSI H510M-A PRO", "motherboard", 61, 5, True, {"ramType": "DDR4"}),
    # --- memory
    ("ram-d4-16", "RAM-D4-16", "Kingston Fury Beast 16GB (1x16GB) DDR4-3200", "ram", 34, 40, True, {"ramType": "DDR4", "modules": 1}),
    ("ram-d4-32", "RAM-D4-32", "Corsair Vengeance LPX 32GB (2x16GB) DDR4-3200", "ram", 62, 25, True, {"ramType": "DDR4", "modules": 2}),
    ("ram-d5-16", "RAM-D5-16", "Kingston Fury Beast 16GB (1x16GB) DDR5-5600", "ram", 49, 30, True, {"ramType": "DDR5", "modules": 1}),
    ("ram-d5-32", "RAM-D5-32", "Corsair Vengeance 32GB (2x16GB) DDR5-6000", "ram", 96, 18, True, {"modules": 2}),
    ("ram-d5-32-z5", "RAM-D5-32-Z5", "G.Skill Trident Z5 RGB 32GB (2x16GB) DDR5-6400", "ram", 128, 6, False, {"modules": 2}),
    # --- storage
    ("ssd-nv2-500", "SSD-NV2-500", "Kingston NV2 500GB NVMe M.2 SSD", "storage", 31, 50, True, {"kind": "nvme"}),
    ("ssd-sn580-1tb", "SSD-SN580-1T", "WD Blue SN580 1TB NVMe M.2 SSD", "storage", 58, 35, True, {"kind": "nvme"}),
    ("ssd-870evo-1tb", "SSD-870EVO-1T", "Samsung 870 EVO 1TB SATA SSD", "storage", 74, 22, True, {"kind": "ssd"}),
    ("hdd-barracuda-2tb", "HDD-BARRA-2T", "Seagate Barracuda 2TB 7200rpm HDD", "storage", 52, 15, True, {"kind": "hdd"}),
    # --- graphics
    ("gpu-gtx1650", "GPU-GTX1650", "NVIDIA GeForce GTX 1650 4GB GDDR6", "gpu", 119, 10, True, {}),
    ("gpu-gtx1660s", "GPU-GTX1660S", "NVIDIA GeForce GTX 1660 Super 6GB", "gpu", 142, 0, False, {}),
    ("gpu-rtx3060", "GPU-RTX3060", "NVIDIA GeForce RTX 3060 12GB", "gpu", 238, 8, True, {}),
    ("gpu-rtx4060", "GPU-RTX4060", "NVIDIA GeForce RTX 4060 8GB", "gpu", 262, 14, True, {}),
    ("gpu-rtx4070s", "GPU-RTX4070S", "NVIDIA GeForce RTX 4070 Super 12GB", "gpu", 548, 5, True, {}),
    ("gpu-rx7600", "GPU-RX7600", "AMD Radeon RX 7600 8GB", "gpu", 241, 9, True, {}),
    ("gpu-rx7800xt", "GPU-RX7800XT", "AMD Radeon RX 7800 XT 16GB", "gpu", 449, 4, False, {}),
    # --- cooling
    ("cool-hyper212", "COOL-HYPER212", "Cooler Master Hyper 212 Black air cooler", "cooling", 29, 30, True, {}),
    ("cool-lf2-240", "COOL-LF2-240", "Arctic Liquid Freezer II 240mm AIO", "cooling", 89, 10, True, {}),
    ("cool-h150i-360", "COOL-H150I-360", "Corsair iCUE H150i 360mm AIO", "cooling", 154, 5, True, {}),
    # --- cases
    ("case-h510", "CASE-H510", "NZXT H510 Mid Tower", "case", 68, 9, True, {}),
    ("case-lancool-216", "CASE-LANCOOL216", "Lian Li LANCOOL 216 Mid Tower", "case", 98, 7, True, {}),
    ("case-pop-mini", "CASE-POP-MINI", "Fractal Design Pop Mini Air", "case", 74, 0, True, {}),
    # --- power supplies
    ("psu-w1-500", "PSU-W1-500", "EVGA W1 500W 80+ White", "psu", 38, 20, True, {}),
    ("psu-cv550", "PSU-CV550", "Corsair CV550 550W 80+ Bronze", "psu", 49, 18, True, {}),
    ("psu-rm750e", "PSU-RM750E", "Corsair RM750e 750W 80+ Gold", "psu", 104, 12, True, {}),
    ("psu-focus-850", "PSU-FOCUS-850", "Seasonic Focus GX-850 850W 80+ Gold", "psu", 132, 6, True, {}),
]

# Products the ERP has no special price for: they fall back to the normal list price.
NO_SPECIAL_PRICE = {"RAM-D5-32-Z5", "COOL-H150I-360", "CASE-POP-MINI"}

products, pricelist = [], {}
for pid, sku, name, category, base, stock, published, attributes in ROWS:
    wholesale = round(base + rng.random(), 2)           # cents, so rounding actually matters
    list_price = round(base * rng.uniform(1.32, 1.48))  # storefront list ("card") price
    products.append({
        "id": pid, "sku": sku, "name": name, "category": category,
        "price": list_price, "stock": stock, "published": published, "attributes": attributes,
    })
    if sku not in NO_SPECIAL_PRICE:
        pricelist[sku] = wholesale

config = {"currency": "USD", "nativeTransferRate": 0.25}

OUT.mkdir(parents=True, exist_ok=True)
for name, data in (("products", products), ("pricelist", pricelist), ("config", config)):
    (OUT / f"{name}.json").write_text(json.dumps(data, indent=2) + "\n")
print(f"{len(products)} products, {len(pricelist)} special prices")
