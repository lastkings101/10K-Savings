# $10K Savings Chart: setup

Hosted on GitHub Pages, with sign-in and saved progress powered by Supabase (free tier).

## 1. Create the Supabase project
1. Sign up at supabase.com and create a new project.
2. Open **SQL Editor > New query**, paste the contents of `schema.sql`, and click **Run**.
3. Open **Project Settings > API** and copy:
   - **Project URL**
   - **anon public** key
   Do **not** use the `service_role` key anywhere in the page.

## 2. Add your keys to the page
In `index.html`, replace the two placeholders near the bottom:
```js
var SUPABASE_URL = "PASTE_YOUR_PROJECT_URL_HERE";
var SUPABASE_ANON_KEY = "PASTE_YOUR_ANON_PUBLIC_KEY_HERE";
```
The anon key is safe to publish. The row-level security rules in `schema.sql` are what protect each person's data.

## 3. Publish on GitHub Pages
1. Create a new repository (for example `10k-savings`) and upload `index.html`.
2. Go to **Settings > Pages**, set **Source** to your main branch (root), and save.
3. Your app will be live at `https://YOUR-USERNAME.github.io/10k-savings/`.

## 4. Tell Supabase your live address
In **Authentication > URL Configuration**, set:
- **Site URL:** your GitHub Pages address
- **Redirect URLs:** add the same address (needed for password reset and email confirmation links)

## 5. Make yourself the admin
1. Open your live app and create an account with your own email.
2. In the SQL Editor, run:
   ```sql
   update public.profiles set is_admin = true where email = 'you@example.com';
   ```
3. Sign in again. An **Admin** table now appears at the bottom, showing each member's pay checks saved.

## Good to know
- **Email confirmation:** by default Supabase emails a confirmation link on sign-up. You can turn this off under **Authentication > Providers > Email** if you'd rather not require it.
- **Free email limit:** Supabase's built-in email sender is rate limited. For a larger group, set up your own SMTP under **Authentication > SMTP Settings**.
- **Privacy:** you collect email addresses and savings progress. Let your friends know what you store and who can see it (only you, as admin).
- **Resetting someone's progress or removing a member:** use the Supabase dashboard (**Authentication > Users** and **Table Editor**).
