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


# TODO 
* write pre-commit script that checks that the version has been bumped from the origin/main
  * git fetch
  * get version from VERSION file
  * server compare between $(git show HEAD:VERSION) and $(git show origin/main:VERSION)
* write the same semver check but as github action workflow step
* Require the check to pass in th
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
  * Block force pushes
  

# References

* Managing a merge queue [^mergequeue]
* [GitHub Actions Marketplace]

[^mergequeue]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue 
[GitHub Actions Marketplace]: https://github.com/marketplace?verification=verified_creator&type=actions