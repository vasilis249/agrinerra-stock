-- 005_orders_status.sql · ΜΟΝΟ αν η εφαρμογή πει ότι η βάση δεν δέχεται την κατάσταση «Καθ' οδόν».
-- Αφαιρεί τον περιορισμό που επιτρέπει μόνο τις παλιές τιμές στη στήλη orders.status.
-- Δεν αλλάζει κανένα δεδομένο. Supabase: SQL Editor -> New query -> επικόλληση -> Run.
alter table orders drop constraint if exists orders_status_check;
