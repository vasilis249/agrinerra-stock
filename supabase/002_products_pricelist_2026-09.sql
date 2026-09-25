-- 002_products_pricelist_2026-09.sql
-- Προσθέτει τα προϊόντα του τιμοκαταλόγου Schaumann «Griechenland - Innera-Esperia», 01/09/2026:
-- μόνο όνομα και τεμάχια ανά παλέτα.
-- Είναι ΜΙΑ εντολή: ή γίνεται ολόκληρη ή δεν γίνεται τίποτα.
-- Δεν αλλάζει και δεν σβήνει υπάρχοντα προϊόντα· μόνο συμπληρώνει τα τεμάχια ανά παλέτα όπου λείπουν.
-- Μπορεί να τρέξει ξανά χωρίς να φτιάξει διπλά.
-- Supabase: SQL Editor -> New query -> επικόλληση ΟΛΟΥ του αρχείου -> Run.
-- Στο αποτέλεσμα βλέπεις τα προϊόντα που προστέθηκαν (κενό αν υπήρχαν ήδη όλα).

with pricelist(id, article, name, bags_pallet) as (
  values
  ('231267-0030', '231267-0030', 'RINDAVITAL VK CLASSIC', 36),
  ('232120-0000', '232120-0000', 'MELOVIT FLÜSSIG (5 ltr.)', 0),
  ('232214-0025', '232214-0025', 'KALBI MILCH FIT', 40),
  ('234068-0025', '234068-0025', 'SCHAUMANN FASERNKONZENTRAT GRA', 33),
  ('235495-0030', '235495-0030', 'SCHAUMASAN BASIS', 30),
  ('235997-0025', '235997-0025', 'SCHAUMASAN CONTROL', 39),
  ('237816-0000', '237816-0000', 'TIRSANA 1312 EU', 0),
  ('238009-0025', '238009-0025', 'KALBI MILCH PRIMUS PROTECT', 30),
  ('238014-0000', '238014-0000', 'KALBI VITAL', 364),
  ('238037-0030', '238037-0030', 'KALVICIN', 39),
  ('238055-0025', '238055-0025', 'KALBI MILCH TOP', 40),
  ('238163-0025', '238163-0025', 'PROFISTREU LB', 36),
  ('238727-0025', '238727-0025', 'BI-LACTAL PLASMA', 30),
  ('321162-0025', '321162-0025', 'RINDAMAST UNI P', 36),
  ('321261-0030', '321261-0030', 'RINDAVIT K 11 RVI BP', 36),
  ('321502-0025', '321502-0025', 'RINDAMAST K SPEZIAL ASS-CO BP', 40),
  ('322616-0020', '322616-0020', 'TRI-OVITAL MAIS', 48),
  ('322632-0020', '322632-0020', 'OVITAL INTENSIV W (aus FW)', 50),
  ('322635-0030', '322635-0030', 'OVITAL A', 35),
  ('322637-0030', '322637-0030', 'OVITAL MM CV', 36),
  ('322700-0030', '322700-0030', 'OVITAL MM-E CV', 36),
  ('322773-0020', '322773-0020', 'OVITAL PRE MM CV - 10', 60),
  ('322806-0025', '322806-0025', 'MILLAPHOS Z', 42),
  ('322823-0025', '322823-0025', 'MILLAPHOS L', 36),
  ('322824-0025', '322824-0025', 'MILLAPHOS WEIDE', 42),
  ('322855-0025', '322855-0025', 'MILLAPHOS PRO', 39),
  ('322871-0025', '322871-0025', 'MILLAPHOS Z OLYMPOUS', 36),
  ('322903-0025', '322903-0025', 'MILLAPHOS Z 15', 36),
  ('322905-0025', '322905-0025', 'MILLAPHOS Z 15 RVI', 42),
  ('322927-0025', '322927-0025', 'MILLAPHOS Z 15 RVI ATG', 42),
  ('323005-0025', '323005-0025', 'SCHAUMAPHOS M 60', 40),
  ('323161-0025', '323161-0025', 'SCHAUMA PRO M 55 M', 36),
  ('323172-0030', '323172-0030', 'SCHAUMAPRO VM 80 / M', 36),
  ('323457-0030', '323457-0030', 'SCHAUMASAN', 30),
  ('324016-0030', '324016-0030', 'SCHAUMAPHOS Z', 36),
  ('324026-0030', '324026-0030', 'SCHAUMA PRO ZL 60 ATG', 36),
  ('324028-0030', '324028-0030', 'SCHAUMA PRO ZT 40 ATG', 36),
  ('324065-0030', '324065-0030', 'SCHAUMAPRO Z 50', 36),
  ('324216-0020', '324216-0020', 'MINERAL ZT 90-10', 50),
  ('324249-0020', '324249-0020', 'MINERAL ZL 210-10 PROTECT ATG', 50),
  ('325591-0025', '325591-0025', 'PRE-NATUPIG M 200-1,5', 36),
  ('326020-0025', '326020-0025', 'RINDAMAST E', 42),
  ('326022-0030', '326022-0030', 'RINDAMAST V', 36),
  ('326031-0030', '326031-0030', 'RINDAMIN LF', 36),
  ('326126-0005', '326126-0005', 'RINDAVITAL ENERGIETRUNK', 100),
  ('326156-0025', '326156-0025', 'RINDAVITAL VK', 39),
  ('326195-0030', '326195-0030', 'RINDAVIT TMR 91', 36),
  ('326265-0030', '326265-0030', 'RINDAVIT K11 ASS-CO ATG', 36),
  ('326335-0030', '326335-0030', 'RINDAMIN BP', 36),
  ('326434-0030', '326434-0030', 'RINDAVIT K 11 ATG', 36),
  ('326459-0025', '326459-0025', 'RINDAMAST UNI', 39),
  ('326462-0030', '326462-0030', 'RINDAMAST FINISHER', 36),
  ('327784-0030', '327784-0030', 'RINDAVIT K11 RVI ATG', 36),
  ('328023-0004', '328023-0004', 'KALBI-LYT', 50),
  ('328576-0020', '328576-0020', 'SCHAUMAPRO F 80 / M', 50),
  ('329120-0025', '329120-0025', 'NATUPIG PRE IMMUNO', 36),
  ('328692-0020', '328692-0020', 'SCHAUMAPRO PROTECT F 95', 48),
  ('328704-0020', '328704-0020', 'MINERAL F 240-15', 50),
  ('328810-0020', '328810-0020', 'MINERAL F 240-20', 50),
  ('329183-0030', '329183-0030', 'SCHAUMAPRO F 35 PLASMA+FISCH G', 30),
  ('902237-0001', '902237-0001', 'KALBI-FERM 2x 500g', 0),
  ('902831-0010', '902831-0010', 'LAMB MILK', 0),
  ('232913-0020', '232913-0020', 'MILLAPHOS LECKSCHALE ATG', 24),
  ('236202-0100', '236202-0100', 'SCHAUMANN LECKMASSE', 4),
  ('236204-0065', '236204-0065', 'RINDAVIT PRE-LICK ATG', 9),
  ('236220-0010', '236220-0010', 'SCHAUMANN LECKSTEIN', 96),
  ('237924-0025', '237924-0025', 'SCHAUMANN LECKMASSE', 24),
  ('322892-0015', '322892-0015', 'MILLAPHOS LECKSCHALE GR', 30),
  ('275626-0025', '275626-0025', 'SCHAUMACID GEL', 36),
  ('275704-1100', '275704-1100', 'SWEET LIQUID', 1),
  ('325804-0025', '325804-0025', 'SCHAUMACID A GRANULAT', 36),
  ('324951-0000', '324951-0000', 'BONCROP FLOW 10L', 60),
  ('326707-0000', '326707-0000', 'BONSILAGE ALFA 100G (konv)', 1800),
  ('BONSILAGE-ALFA-400G-KONV', 'xx6907-0000', 'BONSILAGE ALFA 400G (konv)', 700),
  ('BONSILAGE-ALFA-100G-OEKO', 'xx67xx-0000', 'BONSILAGE ALFA 100G (öko)', 1800),
  ('326727-0000', '326727-0000', 'BONSILAGE SPEED G 100G (konv)', 1800),
  ('BONSILAGE-SPEED-G-400G-KONV', 'xx6927-0000', 'BONSILAGE SPEED G 400G (konv)', 700),
  ('BONSILAGE-SPEED-G-100G-OEKO', 'xx67xx-0000', 'BONSILAGE SPEED G 100G (öko)', 1800),
  ('326729-0000', '326729-0000', 'BONSILAGE FIT G 100G (konv)', 1800),
  ('326757-0000', '326757-0000', 'BONSILAGE SPEED M 100G (konv)', 1800),
  ('BONSILAGE-SPEED-M-400G-KONV', 'xx6957-0000', 'BONSILAGE SPEED M 400G (konv)', 700),
  ('326787-0000', '326787-0000', 'B BONSILAGE SPEED M 100G (öko)', 1800),
  ('326759-0000', '326759-0000', 'BONSILAGE FIT M 100G (konv)', 1800),
  ('BONSILAGE-FIT-M-400G-KONV', 'xx6959-0000', 'BONSILAGE FIT M 400G (konv)', 700),
  ('BONSILAGE-FIT-M-100G-OEKO', 'xx67xx-0000', 'BONSILAGE FIT M 100G (öko)', 1800),
  ('326713-0000', '326713-0000', 'BONSILAGE PLUS 100G (konv)', 1800),
  ('BONSILAGE-PLUS-400G-KONV', 'xx6913-0000', 'BONSILAGE PLUS 400G (konv)', 700),
  ('BONSILAGE-PLUS-100G-OEKO', 'xx67xx-0000', 'BONSILAGE PLUS 100G (öko)', 1800),
  ('326715-0000', '326715-0000', 'BONSILAGE MAIS 100G (konv)', 1800),
  ('BONSILAGE-MAIS-400G-KONV', 'xx6915-0000', 'BONSILAGE MAIS 400G (konv)', 700),
  ('BONSILAGE-MAIS-100G-OEKO', 'xx67xx-0000', 'BONSILAGE MAIS 100G (öko)', 1800),
  ('436740-0000', '436740-0000', 'MIXING BUCKET 2,5L', 0),
  ('906799-0000', '906799-0000', 'MIXING BUCKET 17L', 0)
),
filled as (
  update products p
     set bags_pallet = v.bags_pallet
    from pricelist v
   where coalesce(p.bags_pallet, 0) = 0
     and not coalesce(p.no_pallet, false)
     and v.bags_pallet > 0
     and (p.id::text = v.id or p.id::text = v.article or coalesce(p.code, '') = v.article
          or upper(regexp_replace(trim(p.name), '\s+', ' ', 'g')) = upper(v.name))
  returning p.id
)
insert into products (id, name, bags_pallet)
select v.id, v.name, v.bags_pallet
  from pricelist v
 where not exists (
   select 1 from products p
    where p.id::text = v.id or p.id::text = v.article or coalesce(p.code, '') = v.article
       or upper(regexp_replace(trim(p.name), '\s+', ' ', 'g')) = upper(v.name))
returning id as "κωδικός", name as "προϊόν", bags_pallet as "τεμάχια ανά παλέτα";
