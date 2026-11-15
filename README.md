# SANZONE EXCEL

A responsive browser-based spreadsheet workspace for iPhone, Android and laptop.

## Included
- Create blank workbooks and add worksheets
- Import `.xlsx`, `.xls`, and `.csv` files
- Edit cell values in a simple spreadsheet grid
- Add rows and columns
- Download workbooks as `.xlsx`
- Supabase email/password authentication
- Private Supabase Storage bucket for workbook files
- Owner-only Row Level Security policies for file metadata and storage objects
- Dashboard with live local clock, file count and account file-size total
- Responsive white-theme interface

## Quick setup

1. Create a project at https://supabase.com.
2. Open **SQL Editor** in your Supabase project.
3. Paste all contents of `supabase_setup.sql` and click **Run**.
4. In Supabase **Project Settings → API**, copy:
   - Project URL
   - Publishable key (`sb_publishable_...`) or legacy `anon` key
5. Open `index.html` in a modern browser, go to **Connect Supabase** or **Settings**, and save the URL and key.
6. Create an account with your email and password. If email confirmation is enabled, confirm the email.
7. Sign in, create a workbook, and click **Save to cloud**.

## Deploy free

You can deploy the folder to a static host such as Netlify, Cloudflare Pages or GitHub Pages:
- Upload the contents of this folder (at minimum `index.html`) to your static hosting provider.
- No server-side secrets are required. The browser uses the Supabase public publishable/anon key.
- Add your deployed site URL to Supabase **Authentication → URL Configuration → Redirect URLs** if required by your auth settings.

## Security notes
- Only use the Supabase **publishable** key or legacy **anon** key in this browser app.
- Never use the `service_role` key or any secret key in HTML, JavaScript, a public repository, or a browser.
- The SQL enables RLS and restricts rows and Storage objects to the authenticated owner.
- The URL and public key are saved in this browser's localStorage. Avoid saving them on shared/public devices.
- Supabase authentication passwords are handled by Supabase Auth; the app does not store your password.
- Storage dashboard here totals the sizes of SANZONE files listed for the signed-in account. It does not report the full project-wide quota or billing usage.
- The spreadsheet editor is a lightweight cell editor, not a full Microsoft Excel replacement. It imports/exports workbook content through SheetJS; advanced Excel features, macros, charts, formulas, formatting fidelity and some special workbook features may not be preserved when editing and re-exporting.

## Limits / troubleshooting
- The SQL configures a 50 MB per-file upload limit. Change `file_size_limit` in the bucket SQL if you need a different limit within your Supabase plan limits.
- If the app reports a missing table/bucket, rerun `supabase_setup.sql` in the correct Supabase project.
- If sign-up says confirmation is required, check your inbox and confirm the address.
- If the app is opened as a local file and auth redirects do not work as expected, deploy it to a static HTTPS host and add that URL to Supabase Auth redirect settings.
- External libraries are loaded from jsDelivr, so internet access is needed.
