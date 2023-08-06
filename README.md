## Reproduction Steps

Run `pre-commit run prettier --files test.js`.

This should write to `test.js` but instead it fails with an error like this:

> Executable `/nix/store/apjv7ccblhywdccadbpb2w0ghd0k20fb-prettier` not found

I expected this configuration to use the executable inside of `node_modules`.
