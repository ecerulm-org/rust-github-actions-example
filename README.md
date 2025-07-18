# Purpose 

This is just a test to setup a CI/CD with GitHub Actions that will 
deploy each commit to `main` branch to DockerHub. 

The idea is to set protected branch 
* Use GitHub merge queue in `main` branch
* Require merge method: squash
* Only merge non-failing pull requests
* Set merge limits

The PRs must bump the version in the PR itself.

I'm trying to **avoid**  having a CI/CD step that 

* bumps the version
* creates a new commit
* Pushes the commit (with `-o ci.skip`)

# pre-commit hook

Run `pre-commit install`  to install the hooks. 

The [.pre-commit-config.yaml](.pre-commit-config.yaml) 
calls the [`check_bump_version.sh`](check_bump_version.sh).

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
    * "Check version bumped" (which is the jobname for job id `check-version-bumped`)
    * "cargo test" (which is the jobname for job id `test`)
  * Block force pushes
  

# References

* Managing a merge queue [^mergequeue]
* [GitHub Actions Marketplace][GitHub Actions Marketplace]
* [merge_group event][merge_group]

[^mergequeue]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue 
[GitHub Actions Marketplace]: https://github.com/marketplace?verification=verified_creator&type=actions
[merge_group]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue#triggering-merge-group-checks-with-github-actions
