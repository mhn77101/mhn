# Health Tours v2.2 - Reconstructed clean-install SQL

This is NOT the missing Deep Research original. It is a reconstructed SQL installer with 4119863 characters split into 9 sequential SQL parts for reliable GitHub upload.

The installer includes 26 countries, 69 cities (30 Turkey, 15 Iran), 32 languages, 20 treatments, 1380 candidate offerings, 200 treatment FAQs, 13800 draft offering FAQs, 1495 draft SEO records, 14 unverified clinic identities, and 1380 additional English editorial work files.

All offering drafts are noindex/unpublished and are NOT researched, medically approved or provider-verified. No doctors or prices are invented. Do not publish drafts for SEO.

**WARNING: CLEAN INSTALL DELETES MATCHING TABLES. BACK UP YOUR DATABASE. TEST ON A SEPARATE DATABASE.**

## macOS / Linux: build ONE SQL file
Download the repository as ZIP and unzip it. In Terminal, open the folder containing the part files and run:

```sh
cat healthtours-v2.2-part*.sql > healthtours-full-clean-install-v2.2.sql
```

The assembled file is the complete SQL and can be imported via phpMyAdmin after testing. Alternatively import part01, part02, ... in order into an empty test database.

## Verification
After importing, check the validation queries in the final part and confirm the offering editorial drafts count is 1380, with zero published drafts. This SQL has not been tested on a live Hostinger MySQL instance.

This SQL schema is reconstructed and is NOT guaranteed compatible with an existing Node.js application. Review the application queries before deploying.
