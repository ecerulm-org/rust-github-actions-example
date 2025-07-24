# Purpose 

This is just a test to demonstrate Continuous Deployment setup. 

It will deploy each commit in `main` branch to DockerHub. 

Every commit in main is deployable, which implies that each commmit
in `main branch` has a different version number (stored in [VERSION.txt](VERSION.txt).

The developer is responsible for bumping the version number on each PR. 

In order to ensure that each commit has different [`VERSION.txt`](VERSION.txt)
the following has been setup.

* a `pre-commit` configuration file [`.pre-commit-config.yaml`](.precommit-config.yaml) which ensures that the PR has bumped the
  version number locally with respect to the version currently in `origin/main`.
  This is implemented by [check_version_bump.sh](check_version_bump.sh)
* a GitHub Actions workflow for the PR that ensures that the PR bumps 
  the version with respect to `origin/main`.
  The GitHub status checks will fail if the version is not bumped. 
  The workflow won't update the version number itself. 
  It is still the responsability of the developer to "fix the PR" by 
  bumping the version.
* a branch protection rule in GitHub for `main` to "Require branches to be up to date before merging"
  * Although the merge queue provides the same benefits as this. 
  * I guess it's better to get feedback that the PR needs to bump the version earlier, before trying to merge
* a GitHub merge queue
  * it serializes the merges
  * it runs the `merge_group` trigger before actually merging,
  * that way we can actually ensure that each commit in `main` has a bumped version
  * the pre-commmit and PR workflow part were only early warning systems
  






# Advantages and drawbacks

* This way ensures each commit in `main` has a stricly increasing [`VERSION.txt`](VERSION.txt)
  * Having the version number in the source code can be useful.
* It has the disadvantage of forcing the developer to explicitly update the [`VERSION.txt`](VERSION.txt) 
  * Every PR has to update this file so it becomes a nuisance for the developer



# Alternatives

* Give up on the notion of having the version number on the source code.
  * Have the deployment pipline compute the version.
  * Build script can use the version, never commiting to git
* Have the CI/CD bump the version and create a new commit.
  * I guess in this case it will be wise to have a `develop` and a `main` branch.
  * `develop` is where PR will merge (after the CI/CD passes)
  * there won't be versions in the `develop` branch
  * For each commit in `develop` another CI/CD workflow will run that 
    * bumps the version and creates a commit in `main`
    * The commits in `main` are the one that get deployed



# pre-commit hook

Run `pre-commit install`  to install the hooks. 

The [.pre-commit-config.yaml](.pre-commit-config.yaml) 
calls the [`check_version_bump.sh`](check_version_bump.sh).

This script will 
* `git fetch` to update the `origin/main` ref
* Use the `pysemver` to bump the patch version of whatever version is in `origin/main`
  * the version is stored in file [VERSION.txt](VERSION.txt)
  * the latest version in `origin/main` is retrieved via `$(git show origin/main:VERSION.txt)`

# TODO 

* Setup GitHub artifacts so that the test job uses the executable for the build job

# GitHub settings for this repo 

* In [Settings > General](https://github.com/ecerulm-org/rust-github-actions-example/settings)
  * Disable Wiki, Issues, Sponsorships, Preserve this repository, Disussions and Projects
  * Pull Requests
    * only "Allow squash commits (Pull request title and description)"
    * Always suggest updating pull request branches
    * Allow auto merge
    * Automatically delete head branches
* In [Settings > Actions](https://github.com/ecerulm-org/rust-github-actions-example/settings/actions)
  * Allow all actions and reusable workflows
  * Require approval for all external contributors
  * Read repository contents and packages permissions
* In [Rules > Rulesets](https://github.com/ecerulm-org/rust-github-actions-example/settings/rules)
  * Create rule for main branch
  * Restrict deletions
  * Require linear history
  * Require merge queue
  * Require signed commits
  * Require a pull request before merge
  * Require status checks to pass
    * Require branches to be up to date before merging
    * "Check version bumped" (which is the [jobname for job id `check-version-bumped`](https://github.com/ecerulm-org/rust-github-actions-example/blob/d2585216a3fb2e537c750f4ca5fcd369ccb0077a/.github/workflows/rust.yml#L33))
    * "cargo test" (which is the [jobname for job id `test`](https://github.com/ecerulm-org/rust-github-actions-example/blob/d2585216a3fb2e537c750f4ca5fcd369ccb0077a/.github/workflows/rust.yml#L23)) 
  * Block force pushes
  

# References

* [Managing a merge queue][mergequeue]
* [GitHub Actions Marketplace]
* [merge_group event][merge_group]
* [cargo release version][cargo-release]
* [cargo set-version][cargo-edit]


[GitHub Actions Marketplace]:  https://github.com/marketplace?verification=verified_creator&type=actions
[merge_group]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue#triggering-merge-group-checks-with-github-actions
[mergequeue]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue
[cargo-release]: https://github.com/crate-ci/cargo-release
[cargo-edit]: https://github.com/killercup/cargo-edit/blob/master/README.md#available-subcommands
