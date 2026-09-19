# Mangalore Trip Expense Manager

Live shared trip expense dashboard.

## Access model
- Normal users: open the public URL directly; no login; read-only.
- Admin: signs in through **Admin Login** and can add/edit/delete members and add/delete expenses.
- Database RLS ensures that being signed in is NOT enough: only users listed in `admin_users` can write.

## Initial trip data
17 members • expected ₹22,700 • received ₹15,000 • pending ₹7,700 • resort ₹9,500.

## Setup
1. Create a Supabase project.
2. Open SQL Editor and run `supabase-schema.sql`.
3. In Supabase Authentication, create the one admin email/password.
4. Copy that user's Auth UUID.
5. In SQL Editor run: `insert into public.admin_users(user_id) values ('YOUR-UUID') on conflict do nothing;`
6. In `app.js`, replace `PASTE_SUPABASE_URL_HERE` and `PASTE_SUPABASE_ANON_KEY_HERE` with your Supabase Project URL and public anon key.
7. Enable GitHub Pages for this public repository: Settings → Pages → Deploy from branch → main → /(root).
8. Share the GitHub Pages URL with the group.

Never put a Supabase service_role/secret key in the frontend.
