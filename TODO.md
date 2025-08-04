Manual Setup Tasks
==================
After running `./configure.sh`, complete these manual tasks to enable automated releases and Homebrew distribution.


Required Tasks
--------------
### 1. Create Homebrew Tap Repository
If you didn't do it as part of `configure.sh`, you need to create a Github repository to hold your Homebrew tap:

- [ ] Go to GitHub and create a new repository: https://github.com/new
- [ ] Name it `TEMPLATE_TAP_NAME`
- [ ] Make it **public** (Homebrew taps must be public)
- [ ] **Do not** add any other files - GoReleaser will manage the Homebrew Formula

### 2. Generate GitHub Personal Access Token
You need a GitHub Personal Access Token for GoReleaser to push to your Homebrew tap:

- [ ] Go to GitHub Settings → Developer settings → Personal access tokens → Fine-grained tokens: https://github.com/settings/personal-access-tokens
- [ ] Click "Generate new token"
- [ ] Give it a descriptive name like "GoReleaser Homebrew Tap"
- [ ] Set expiration (recommend 1 year or no expiration for automation)
- [ ] Give it repository access to your `TEMPLATE_TAP_NAME` repository
- [ ] Add the `Contents` permission with `Read and write` access
- [ ] Click "Generate token"
- [ ] **Copy the token immediately** for use later (you won't be able to see it again)

### 3. Add GitHub Repository Secret
Add the token you just generated as a repository secret to this repo (not `TEMPLATE_TAP_NAME`!) on Github:

- [ ] In this repository, go to Settings → Secrets and variables → Actions → New repository secret: https://github.com/TEMPLATE_USERNAME/TEMPLATE_REPO_NAME/settings/secrets/actions
- [ ] Name: `HOMEBREW_TAP_GITHUB_TOKEN`
- [ ] Value: Paste the Personal Access Token that you generated previously
- [ ] Click "Add secret"

### 4. Verify GoReleaser Configuration
Double-check that the `.goreleaser.yaml` file in this repo has the correct values. The `configure.sh` should have slotted everything into place, but you should double-check:

- [ ] `project_name` matches your CLI binary name
- [ ] `builds[0].binary` matches your CLI binary name
- [ ] `brews[0].repository.owner` matches your GitHub username
- [ ] `brews[0].repository.name` matches your Homebrew tap repository name
- [ ] `brews[0].homepage` has the correct repository URL
- [ ] `brews[0].description` has your CLI description
- [ ] `brews[0].test` command uses the correct binary name
- [ ] `brews[0].install` command uses the correct binary name


Optional Tasks
--------------
### 5. Add License File
Consider adding a license to your project:

- [ ] Create a `LICENSE` file in your repository root
- [ ] Choose an appropriate license (MIT is common for CLI tools)
- [ ] Update the `license` field in `.goreleaser.yaml` if you choose something other than MIT

Testing Your Setup
------------------
### Test Local Build
- [ ] Run `./build.sh` to ensure your CLI builds correctly
- [ ] Test your CLI: `./build/TEMPLATE_CLI_NAME --help`
- [ ] Test version command: `./build/TEMPLATE_CLI_NAME version`

### Test Release Process (Dry Run)
Before creating your first real release, you can test GoReleaser:

- [ ] Run dry-run: `goreleaser release --snapshot --clean` (GoReleaser is pre-installed in the devcontainer)
- [ ] Check the `dist/` directory for generated artifacts

### Create First Release
When everything is working:

- [ ] Commit all your changes: `git add . && git commit -m "feat: initial CLI implementation"`
- [ ] Create and push a tag: `git tag v0.1.0 && git push origin main --tags`
- [ ] Watch the GitHub Actions workflow run: https://github.com/TEMPLATE_USERNAME/TEMPLATE_REPO_NAME/actions
- [ ] Verify the release appears in your GitHub repository: https://github.com/TEMPLATE_USERNAME/TEMPLATE_REPO_NAME/releases
- [ ] Check that your `TEMPLATE_TAP_NAME` repository gets updated with a new Formula: https://github.com/TEMPLATE_USERNAME/TEMPLATE_TAP_NAME

Troubleshooting
---------------
### Common Issues
**Build fails:**
- Ensure `go mod tidy` has been run
- Verify all import paths in your Go files are correct
- Check that your module name in `go.mod` matches the import paths

**GoReleaser fails with authentication error:**
- Verify your `HOMEBREW_TAP_GITHUB_TOKEN` secret is set correctly: 
- Ensure the token has the `Read and write` access
- Check that your `TEMPLATE_TAP_NAME` repository exists and is public

**Formula not appearing in Homebrew tap:**
- Ensure your Homebrew tap repository name follows the `homebrew-<name>` pattern
- Verify the repository is public
- Check the GoReleaser logs in GitHub Actions for specific errors: https://github.com/TEMPLATE_USERNAME/TEMPLATE_REPO_NAME/actions

### Getting Help
- [ ] Check the [GoReleaser documentation](https://goreleaser.com/)
- [ ] Review the [GitHub Actions logs](https://github.com/TEMPLATE_USERNAME/TEMPLATE_REPO_NAME/actions) if releases fail
- [ ] Test locally with `goreleaser release --snapshot --clean`
