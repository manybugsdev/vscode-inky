# GitHub Actions Workflows

This directory contains the CI/CD workflows for the vscode-inky extension.

## Workflows

### CI Workflow (`ci.yml`)

**Trigger:** Runs on every pull request and push to the `main` branch.

**Purpose:** Ensures code quality by running tests and checks on all changes.

**Steps:**
1. Checkout code
2. Setup Node.js 22 with pnpm caching
3. Install pnpm package manager
4. Install dependencies
5. Run TypeScript type checking
6. Run ESLint
7. Build the extension
8. Run tests (using xvfb for VS Code UI testing)

### Publish Workflow (`publish.yml`)

**Trigger:** Runs when `package.json` is pushed to the `main` branch.

**Purpose:** Automatically creates GitHub releases and publishes to the VS Code Marketplace when the version number changes.

**Workflow Jobs:**

#### 1. `check-version`
Compares the current version in `package.json` with the previous commit to determine if the version has changed.

**Outputs:**
- `version`: The current version from package.json
- `version_changed`: Boolean indicating if version changed

#### 2. `publish`
Only runs if the version has changed. Performs the following:

1. Checkout code
2. Setup Node.js 22 with pnpm caching
3. Install pnpm package manager
4. Install dependencies
5. Run TypeScript type checking
6. Run ESLint
7. Build the extension
8. Run tests
9. Package the extension as `.vsix` file
10. Create a GitHub release with tag `v{version}`
11. Upload the `.vsix` file to the GitHub release
12. Publish to VS Code Marketplace

## Required Secrets

To enable automatic publishing, you need to configure the following secret in your GitHub repository:

### `VSCE_PAT`
A Personal Access Token from Azure DevOps for publishing to the VS Code Marketplace.

**How to create:**
1. Go to https://dev.azure.com
2. Click on your profile icon → Security → Personal access tokens
3. Click "New Token"
4. Set the following:
   - Name: "vscode-inky marketplace publisher"
   - Organization: All accessible organizations
   - Expiration: Custom (set to desired duration)
   - Scopes: Custom defined → Marketplace → **Manage** (select this scope)
5. Click "Create" and copy the token
6. In your GitHub repository, go to Settings → Secrets and variables → Actions
7. Click "New repository secret"
8. Name: `VSCE_PAT`
9. Value: Paste the token you copied
10. Click "Add secret"

## Usage

### For Contributors
- Create a pull request to the `main` branch
- The CI workflow will automatically run tests
- All checks must pass before merging

### For Maintainers
To publish a new version:

1. Update the `version` field in `package.json`
2. Commit and push to the `main` branch (or merge a PR that updates the version)
3. The publish workflow will automatically:
   - Create a GitHub release
   - Upload the extension package
   - Publish to VS Code Marketplace

**Example:**
```bash
# Update version in package.json from 0.0.1 to 0.0.2
npm version patch  # or: npm version minor, npm version major
git push origin main
```

## Troubleshooting

### Tests Failing on CI but Passing Locally
- Ensure all dependencies are listed in `package.json`
- Check that the extension works in a headless environment (xvfb)

### Publish Workflow Not Triggering
- Verify that `package.json` was modified in the commit
- Check that you're pushing to the `main` branch
- Ensure the version number actually changed

### Marketplace Publishing Fails
- Verify that `VSCE_PAT` secret is configured correctly
- Check that the token has the "Marketplace → Manage" scope
- Ensure the token hasn't expired
- Verify that the publisher name in `package.json` matches your marketplace publisher
