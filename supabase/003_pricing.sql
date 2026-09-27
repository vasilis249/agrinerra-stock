-- 003_pricing.sql · Τιμολόγηση
-- Προσθέτει δύο πίνακες για την καρτέλα «Τιμολόγηση». Δεν αλλάζει κανέναν υπάρχοντα πίνακα.
--   app_settings   : οι παράμετροι κόστους (μεταφορά, φόρτωση, αποθήκευση, σενάρια margin)
--   product_prices : βάρος τεμαχίου (κιλά) και τρέχουσα τιμή πώλησης ανά προϊόν
-- Στο τέλος συμπληρώνει από τον τιμοκατάλογο Schaumann 01/09/2026 το βάρος και την τιμή αγοράς
-- (€ ανά τεμάχιο, FCA), ΜΟΝΟ όπου λείπουν. Ό,τι έχεις ήδη γράψει δεν αλλάζει.
-- Μπορεί να τρέξει ξανά χωρίς πρόβλημα.
-- Supabase (project gyelvbcytckwpjecrcnr): SQL Editor -> New query -> επικόλληση ΟΛΟΥ του αρχείου -> Run.

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

-- Βάρος και τιμή αγοράς από τον τιμοκατάλογο, μόνο όπου λείπουν.
-- Το αποτέλεσμα δείχνει σε ποια προϊόντα μπήκε τιμή αγοράς.
with pricelist(article, name, weight_kg, price_eur) as (
  values
    ('231267-0030', 'RINDAVITAL VK CLASSIC', 30, 31.8),
    ('232120-0000', 'MELOVIT FLÜSSIG (5 ltr.)', null, 35),
    ('232214-0025', 'KALBI MILCH FIT', 25, 59.25),
    ('234068-0025', 'SCHAUMANN FASERNKONZENTRAT GRA', 25, 16),
    ('235495-0030', 'SCHAUMASAN BASIS', 30, 44.7),
    ('235997-0025', 'SCHAUMASAN CONTROL', 25, 60.75),
    ('237816-0000', 'TIRSANA 1312 EU', null, 127),
    ('238009-0025', 'KALBI MILCH PRIMUS PROTECT', 25, 65),
    ('238014-0000', 'KALBI VITAL', null, 22),
    ('238037-0030', 'KALVICIN', 27.6923, 31.8461),
    ('238055-0025', 'KALBI MILCH TOP', 25, 68),
    ('238163-0025', 'PROFISTREU LB', 25, 15),
    ('238727-0025', 'BI-LACTAL PLASMA', 25, 83),
    ('321162-0025', 'RINDAMAST UNI P', 25, 16.5),
    ('321261-0030', 'RINDAVIT K 11 RVI BP', 30, 30),
    ('321502-0025', 'RINDAMAST K SPEZIAL ASS-CO BP', 25, 22.75),
    ('322616-0020', 'TRI-OVITAL MAIS', 20, 21.4),
    ('322632-0020', 'OVITAL INTENSIV W (aus FW)', 20, 22.8),
    ('322635-0030', 'OVITAL A', 30, 30.6),
    ('322637-0030', 'OVITAL MM CV', 30, 36.9),
    ('322700-0030', 'OVITAL MM-E CV', 30, 33.6),
    ('322773-0020', 'OVITAL PRE MM CV - 10', 20, 37.4),
    ('322806-0025', 'MILLAPHOS Z', 25, 18),
    ('322823-0025', 'MILLAPHOS L', 25, 17.75),
    ('322824-0025', 'MILLAPHOS WEIDE', 25, 14.5),
    ('322855-0025', 'MILLAPHOS PRO', 25, 16.25),
    ('322871-0025', 'MILLAPHOS Z OLYMPOUS', 25, 23.25),
    ('322903-0025', 'MILLAPHOS Z 15', 25, 24.75),
    ('322905-0025', 'MILLAPHOS Z 15 RVI', 25, 25),
    ('322927-0025', 'MILLAPHOS Z 15 RVI ATG', 25, 27),
    ('323005-0025', 'SCHAUMAPHOS M 60', 25, 18.5),
    ('323161-0025', 'SCHAUMA PRO M 55 M', 25, 20.25),
    ('323172-0030', 'SCHAUMAPRO VM 80 / M', 30, 30),
    ('323457-0030', 'SCHAUMASAN', 30, 38.4),
    ('324016-0030', 'SCHAUMAPHOS Z', 30, 26.1),
    ('324026-0030', 'SCHAUMA PRO ZL 60 ATG', 30, 32.4),
    ('324028-0030', 'SCHAUMA PRO ZT 40 ATG', 30, 30),
    ('324065-0030', 'SCHAUMAPRO Z 50', 30, 30.6),
    ('324216-0020', 'MINERAL ZT 90-10', 20, 32.4),
    ('324249-0020', 'MINERAL ZL 210-10 PROTECT ATG', 20, 43.8),
    ('325591-0025', 'PRE-NATUPIG M 200-1,5', 25, 42.5),
    ('326020-0025', 'RINDAMAST E', 25, 13.25),
    ('326022-0030', 'RINDAMAST V', 30, 18),
    ('326031-0030', 'RINDAMIN LF', 30, 16.8),
    ('326126-0005', 'RINDAVITAL ENERGIETRUNK', 5, 10.35),
    ('326156-0025', 'RINDAVITAL VK', 25, 31.75),
    ('326195-0030', 'RINDAVIT TMR 91', 30, 21.3),
    ('326265-0030', 'RINDAVIT K11 ASS-CO ATG', 30, 30.6),
    ('326335-0030', 'RINDAMIN BP', 30, 21.9),
    ('326434-0030', 'RINDAVIT K 11 ATG', 30, 27.6),
    ('326459-0025', 'RINDAMAST UNI', 25, 14),
    ('326462-0030', 'RINDAMAST FINISHER', 30, 18),
    ('327784-0030', 'RINDAVIT K11 RVI ATG', 30, 42.9),
    ('328023-0004', 'KALBI-LYT', 4, 15.8),
    ('328576-0020', 'SCHAUMAPRO F 80 / M', 20, 27),
    ('329120-0025', 'NATUPIG PRE IMMUNO', 25, null),
    ('328692-0020', 'SCHAUMAPRO PROTECT F 95', 20, 28.8),
    ('328704-0020', 'MINERAL F 240-15', 20, 42.2),
    ('328810-0020', 'MINERAL F 240-20', 20, 41.6),
    ('329183-0030', 'SCHAUMAPRO F 35 PLASMA+FISCH G', 30, null),
    ('232913-0020', 'MILLAPHOS LECKSCHALE ATG', 20, 20.2),
    ('236202-0100', 'SCHAUMANN LECKMASSE', 100, 93),
    ('236204-0065', 'RINDAVIT PRE-LICK ATG', 65, 81.9),
    ('236220-0010', 'SCHAUMANN LECKSTEIN', 10, 4.6),
    ('237924-0025', 'SCHAUMANN LECKMASSE', 25, 24),
    ('322892-0015', 'MILLAPHOS LECKSCHALE GR', 15, 15.75),
    ('275626-0025', 'SCHAUMACID GEL', 25, 37.5),
    ('325804-0025', 'SCHAUMACID A GRANULAT', 25, 40.25),
    ('324951-0000', 'BONCROP FLOW 10L', 10, 125),
    ('326707-0000', 'BONSILAGE ALFA 100G (konv)', 0.1, 67.75),
    ('xx6907-0000', 'BONSILAGE ALFA 400G (konv)', 0.4, 269.5),
    ('xx67xx-0000', 'BONSILAGE ALFA 100G (öko)', 0.1, 67.75),
    ('326727-0000', 'BONSILAGE SPEED G 100G (konv)', 0.1, 73.75),
    ('xx6927-0000', 'BONSILAGE SPEED G 400G (konv)', 0.4, 293.5),
    ('xx67xx-0000', 'BONSILAGE SPEED G 100G (öko)', 0.1, 73.75),
    ('326729-0000', 'BONSILAGE FIT G 100G (konv)', 0.1, 71.75),
    ('326757-0000', 'BONSILAGE SPEED M 100G (konv)', 0.1, 71),
    ('xx6957-0000', 'BONSILAGE SPEED M 400G (konv)', 0.4, 281),
    ('326787-0000', 'B BONSILAGE SPEED M 100G (öko)', 0.1, 71),
    ('326759-0000', 'BONSILAGE FIT M 100G (konv)', 0.1, 71),
    ('xx6959-0000', 'BONSILAGE FIT M 400G (konv)', 0.4, 281),
    ('xx67xx-0000', 'BONSILAGE FIT M 100G (öko)', 0.1, 71),
    ('326713-0000', 'BONSILAGE PLUS 100G (konv)', 0.1, 66.75),
    ('xx6913-0000', 'BONSILAGE PLUS 400G (konv)', 0.4, 265.5),
    ('xx67xx-0000', 'BONSILAGE PLUS 100G (öko)', 0.1, 66.75),
    ('326715-0000', 'BONSILAGE MAIS 100G (konv)', 0.1, 68.5),
    ('xx6915-0000', 'BONSILAGE MAIS 400G (konv)', 0.4, 271),
    ('xx67xx-0000', 'BONSILAGE MAIS 100G (öko)', 0.1, 68.5),
    ('436740-0000', 'MIXING BUCKET 2,5L', null, 5),
    ('906799-0000', 'MIXING BUCKET 17L', null, 15)
),
matched as (
  select distinct on (p.id) p.id, pl.weight_kg, pl.price_eur
    from products p
    join pricelist pl
      on p.id = pl.article or coalesce(p.code, '') = pl.article
      or upper(regexp_replace(trim(p.name), '\s+', ' ', 'g')) = upper(pl.name)
   order by p.id, (p.id = pl.article or coalesce(p.code, '') = pl.article) desc
),
weights as (
  insert into product_prices (product, weight_kg)
  select id, weight_kg from matched where weight_kg is not null
  on conflict (product) do update
    set weight_kg = coalesce(product_prices.weight_kg, excluded.weight_kg)
  returning product
)
update products p
   set price_eur = m.price_eur
  from matched m
 where p.id = m.id and m.price_eur is not null and coalesce(p.price_eur, 0) = 0
returning p.name as "προϊόν", p.price_eur as "τιμή αγοράς € ανά τεμάχιο";
