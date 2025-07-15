# Purpose 

This is just a test to setup a CI/CD with GitHub Actions that will 
deploy each commit to `main` branch to DockerHub. 

The idea is to set protected branch 
* Use GitHub merge queue in `main` branch
* Require merge method: squash
* Only mergenon-failing pull requests
* Set merge limits

The PRs must bump the version in the PR itself.

I'm trying to **avoid**  having a CI/CD step that 

* bumps the version
* creates a new commit
* Pushes the commit (with `-o ci.skip`)

# References

* Managing a merge queue [^mergequeue]

[mergequeue]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue 
