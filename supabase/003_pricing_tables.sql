-- 003_pricing_tables.sql · Τιμολόγηση, βήμα 1 (απαραίτητο)
-- Φτιάχνει τους πίνακες app_settings και product_prices. Δεν αλλάζει υπάρχοντες πίνακες.
-- Supabase: SQL Editor -> New query -> επικόλληση όλου -> Run. Αναμενόμενο: "Success. No rows returned".

create table if not exists app_settings (
  key        text primary key,
  value      jsonb not null,
  updated_at timestamptz default now()
);
alter table app_settings enable row level security;
drop policy if exists "auth all" on app_settings;
create policy "auth all" on app_settings for all to authenticated using (true) with check (true);
grant select, insert, update, delete on app_settings to authenticated;

create table if not exists product_prices (
  product        text primary key references products(id) on delete cascade,
  weight_kg      numeric,
  sale_price_eur numeric,
  updated_at     timestamptz default now()
);
alter table product_prices enable row level security;
drop policy if exists "auth all" on product_prices;
create policy "auth all" on product_prices for all to authenticated using (true) with check (true);
grant select, insert, update, delete on product_prices to authenticated;

insert into app_settings (key, value) values ('pricing', '{
  "palletsPerTruck": 24,
  "margins": [20, 25, 30],
  "costs": [
    {"name": "Μεταφορά",   "amount": 0,     "unit": "truck",  "on": true},
    {"name": "Φόρτωση",    "amount": 4,     "unit": "pallet", "on": true},
    {"name": "Εκφόρτωση",  "amount": 4,     "unit": "pallet", "on": true},
    {"name": "Αποθήκευση", "amount": 0.012, "unit": "kg",     "on": true}
  ]
}'::jsonb)
on conflict (key) do nothing;
