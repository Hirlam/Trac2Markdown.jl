```@meta
EditURL="https://hirlam.org/trac//wiki//SourceCodeRepository?action=edit"
```
# Harmonie Source Code Repository

## Overview
This page contains informations about the source code repository for code revision control of the Harmonie model.

The informations refer to the new code repository administrated under [git](https://git-scm.com)


## User Access

In general, all users with access to hirlam.org have read access to the central public Harmonie repository, but only the system-core staff is granted write access. In order to facilitate repository sharing for all users, each user can establish a user repository, and a *fork* of the official repositories like the Harmonie repository.


### Forking and Cloning #forking

### = General Proceduce=

A fork of the Harmonie git repository is just a clone of the repo on hirlam.org, but optimizing storage resource use. On hirlam.org, the fork is established within the users repository area 'users/<username>'. In order to perform the forking, ssh access is necessary:

```bash
   ssh git@hirlam.org fork Harmonie users/<your username>/Harmonie
```

Unfortunately, users don't have ssh access to 'git' on hirlam.org, unless a public ssh key is being provided and registered. The corresponding personal ssh key has to be used then in order to execute the above ssh command, and in case this one is not the default ssh key on the user's local system, it has to be provided via ssh option `-i`.

Once the fork is established, the user can clone from this [#shareduserrepo user repository]: [=#forkclone]

```bash
   git clone git@hirlam.org:users/<your username>/Harmonie $HOME/repo/users/<your username>/Harmonie
```

Either of these commands establishes the repository on the local filesystem, with the *origin* pointing to the user's repository. So *pushing* will happen onto the //user repository//, and not onto the public repository. Nevertheless, the //user repository// is generally readable for all users on hirlam.org, and thus acts as a repository for [#sharing sharing].

> It is important to note that the forked repository on hirlam.org is *not* automatically updated with updates from the original repository

Updating your forked repository on hirlam.org happens through your local repository, and this is controlled by yourself. In order to be able to do this, however, your local repository needs to be explicitly //connected// to the public repository by establishment of a *remote*:

```bash
   cd $HOME/repo/users/<your username>/Harmonie
   git remote add public git@hirlam.org:Harmonie
```

Check the list of *remotes* within your local user repo by: [=#remotelist]

```bash
   git remote -v
```

This should then show a listing like:

```bash
   origin  git@hirlam.org:users/<your username>/Harmonie (fetch)
   origin  git@hirlam.org:users/<your username>/Harmonie (push)
   public  git@hirlam.org:Harmonie (fetch)
   public  git@hirlam.org:Harmonie (push)
```

where *origin* points to your own user repository, and *public* points to the central public repository. Instead of `'git@hirlam.org:'` the listing may show `'https://git.hirlam.org/'` in case your remotes have been established on basis of https access.

Updating of for example the `develop` branch within your fork on hirlam.org would then be done as follows: [=#updatefork]

```bash
   cd <your local user repo>
   git checkout develop
   git pull public develop
   git push origin develop
```


### = Alternative to fork=

Another alternative to forking is to establish the user repository via a clone:

```bash
   git clone https://git.hirlam.org/Harmonie Harmonie
   git remote rename origin public
   git remote add origin https://git.hirlam.org/users/<your username>/Harmonie
```

This approach, however, does perform a real copy of the public Harmonie repository without storage optimization. In this example, the original clone URL is retained in the remote alias 'public', making it possible to still fetch and pull updates from the public Harmonie repository.

After cloning, move into the created directory in order to start working under the repository.
This cloning checks out the `master` branch of Harmonie. It reflects the official Harmonie releases, which are represented in *tags*.


### Direct Cloning

All users of hirlam.org may also clone the Harmonie git repository via read access as follows:

```bash
   git clone https://git.hirlam.org/Harmonie my_Harmonie
```

Leaving out the *my_Harmonie* specification results in the local directory being called Harmonie like the original one.


### Branches

### = access=

In order to access the branches other than `master` within the Harmonie repository, the list of available //remote// branches can be shown using

```bash
   git branch -a
```
And in order to get a remote branch onto the local clone, it has to be checked out (e.g. the `develop` branch):

```bash
   git checkout develop
```

This creates the local represenation of the `develop` branch. This can be verified by

```bash
   git branch
```

which just lists the local branches, and marks the currently checked out branch.

> NOTE: In order to better facilitate that you can add official updates to your local work, it is recommended that you do not commit to `develop` branch directly, but rather branch off from there for doing development. This leaves the original branch open for easily getting updates. These updates can then be merged into your own development branch (see below). This procedure keeps possible merging conflicts away from the official branches within your local git repository


### = update=

A branch like for example `develop` in your local repository can be updated by:

```bash
   git checkout develop
   git pull <remote> develop
```

where '<remote>' stands for either 'public' or 'origin', depending on, whether you applied a [#forking fork], and how you organized your [#remotelist remotes]

and similarly for [#branches one of the future cycle branches CY'nn']:

```bash
   git checkout CY'nn'
   git pull <remote> CY'nn'
```


### Local Development #localdev

### = create feature branches=

In order to do own development work, it is best practice to create a //feature branch// by branching-off from the desired official development branch. This would be branch `develop` or [#branches one of the future cycle branches CY'nn']. For a cycle related feature development, this would look like:

```bash
   git checkout CY'nn'
   git checkout -b cy'nn'_my_feature
```

Here 'nn' is to be replaced by the number representing the cycle. This creates the feature branch cy'nn'_my_feature on basis of CY'nn', and checks it out for immediately facilitating to start work on it within your local Harmonie git repository.


In case your feature development is to be related to branch `develop`, then the creation of the feature branch could look like:

```bash
   git checkout develop
   git checkout -b cy'dd'_my_feature
```

After checkout of branch `develop`, this creates branch cy'dd'_my_feature on basis of the latest status of branch `develop` within your local Harmonie git repository. Here the cycle number 'dd' would take the number for the cycle that is represented by branch `develop`. At the time of writing, this is cycle 43.

If you want to make sure that you don't miss the very latest official changes to `develop` before branching off, then update `develop` first, and if your local repo is cloned from your [#forking fork], then [#updatefork update your fork branch first]. Then apply the update locally and branch-off:

```bash
   git checkout develop
   git pull origin develop
   git checkout -b cy'dd'_my_feature
```


### = update feature branches= #updatefeaturebranch

In case you have existing feature branches, which have been branched-off from branch `develop` or any of [#branches the other cycle development branches (CY'nn')], then you should update
each feature branch every time after you have updated `develop` or CY'nn' with changes from the public repository, respectively. Updating for example your local `develop` branch would look like (assume [#forking the forking structure]):

```bash
   git checkout develop
   git pull public develop
```


A feature branch can then be updated as follows:

```bash
   git checkout cy'dd'_my_feature
   git merge develop
```

The merge may result in merge conflicts, if your local feature changes conflict with upstream changes. You have to resolve the conflicts in order to finish the update, see [git documantation](http://git-scm.com/book/en/v2) or the manual pages for details. The merge process usually creates a merge commit, unless the merge results in a simple *fast-forward*, and all feature commits you did within your feature branch are retained **as is**

An alternative for updating your feature branch is *rebase*:

```bash
     git checkout cy'dd'_my_feature
     git rebase develop
```

Similar to merge, rebase may result in conflicts, which you have to resolve in order to finish the rebase.

The difference to merge is that rebase reapplies all your feature specific commits on top of the latest commit from `develop`. This means that a new commit is created instead of the old one for each of your feature specific commits. So in the end it may look like as if you had applied all feature specific changes first **after** the latest commit within branch `develop`. However, even though the *commit date* has changed for each of your feature specific commits, the *author date* is **retained**, still pointing to the time, when the feature commit was introduced. This means that the *commit date* marks the rebase action, whereas the *author date* marks the original introcducion of the commit.

> **WARNING:**

> as *rebase* rewrites commit history, you should only apply it upon really local commits, that is commits, that neither have been shared nor published yet

> once there are commits involved that have been published or shared, use *merge*



### Sharing Development #sharing

### = shared user repository= #shareduserrepo

The local development within your local user repository can be shared on hirlam.org via your user repository on the server. This user repository is readable for all registered users on hirlam.org, but only you have write access on it to begin with. A shared user repository is created by one of following actions:

a. by [#forking forking] from the central official repositories - this would for example apply to the Harmonie repository

b. by pushing your local repository towards hirlam.org:

```bash
      git remote add origin git@hirlam.org:users/<your username>/<repository name>
      git push origin master
```


### = granting write access= #grantuserwrite

In order to really share development, you can grant write access to each registered user on hirlam.org separately:

```bash
  ssh git@hirlam.org perms users/<your username>/Harmonie + WRITERS <granted username>
```

this grants write access to your user repository of Harmonie to the user that is specified by '<granted username>'.

> Note: this granted write access to other users allows for push actions into your existing user repositories, but it does not allow for creation of a new repository. If you want to give such create-permission to another user in addition, it is necessary to contact system core group (system-core at hirlam.org).

The list of users, who have write access to your shared user repository can be viewed by:

```bash
  ssh git@hirlam.org perms -l users/<your username>/Harmonie
```

This granted write access can also be revoked by you at any time:

```bash
  ssh git@hirlam.org perms users/<your username>/Harmonie - WRITERS <granted username>
```

Note the tiny difference of **+** and **-** in the syntax.

> Note: the ssh commands for granting write access to your shared user repository are not available, unless your public ssh key is registered for 'git' on hirlam.org. Please contact the system core group and provide your public key for registration.
.


### = setting up //remotes// for sharing=

In order to make sharing of development easier, following //remotes// can be established:


| **//remote//**     | **description** |
| --- | --- |
| origin         | remote link to your own user repository - this exists already, if you [#forkclone cloned form your fork] |
| <sharing user> | remote link to the user repository of a user who shares his/her work with you |

the latter of these two //remotes// is established (for Harmonie repository) as follows:

```bash
  git remote add <sharing user> git@hirlam.org:users/<sharing user>/Harmonie
```

> [[Color(red, BUG)]]: currently the users you share with might have to access your user repository using> 
> {{{
>   https://git.hirlam.org/users/<sharing user>/Harmonie
> }}}
> instead of
> {{{
>   git@hirlam.org:users/<sharing user>/Harmonie
> }}}

Once this is established, sharing is possible in two different ways by use of these //remotes//:

a. if the shared repository is located within your own user repository on hirlam.org
   * receiving updates of `our_feature` from your own user repository, after it was updated by the sharing user
```bash
       git checkout our_feature
       git pull origin our_feature
```
   * sending updates of `our_feature` to your own user repository, for sharing
```bash
       git checkout our_feature
       git push origin our_feature
```

b. if the shared repository is located within the other user's user repository on hirlam.org
   * established the shared branch locally
```bash
       git fetch <sharing user>
       git checkout -b our_feature --track <sharing user>/our_feature
```
   * receiving updates of `our_feature` from the other users' user repository
```bash
       git checkout our_feature
       git pull <sharing user> our_feature
```
   * sending updates of `our_feature` directly to the sharing user's repository (necessitates that the sharing user [#grantuserwrite grants write permission] to you)
```bash
       git checkout our_feature
       git push <sharing user> our_feature
```


### = recommended working practice=

In order to be able to share developments with a minimum of conflicts, it is recommended to make use of branching similar as done for any [#localdev local developments]. So

 
This means, that

> do not commit directly onto the shared branch, but branch-off from it in order to do any local work

This should be always valid, also if your shared branch is a feature branch, which is branched of from `develop`. The fact that another user keeps a local clone of your feature branch, thus sharing that feature branch with you, makes it necessary to keep this branch in a state where it can be updated *at any time*, regardless of the current status of your local work on that feature.

This *branch-off* working practice establishes a hierarchy of branches, which is one of the central concepts of the underlying git work flow.


### Publishing Development

In order for a development to become officially public on the central public Harmonie repository, the commits related to that development have to be pushed to the central public repository.

   > NOTE: only system-core staff have write access to the central public Harmonie repository. You have to contact a system-core staff memeber for adding commits, that you consider mature enough to be added to the official branch.

So instead of directly pushing to the central public Harmonie repository, following procedure applies:

1. Let's assume that:

     * you make use of your own [#forking user repository fork]

     * the relevant commits, are placed within an exclusive feature branch, which is branched-off from branch `develop`, so the feature branch only contains the relevant commits in addition to those that stem from `develop`


2. make sure the feature branch including the new development is mature for publishing


3. update the feature branch to include the latest official upstream changes under `develop` from the central public repository:

   * update `develop` locally and on your user repository
```bash
        git checkout develop
        git pull public develop
        git push origin develop
```

   * merge the upstream changes into your feature branch
```bash
        git checkout <feature branch>
        git merge develop
```
     and resolve possible conflicts (<feature branch> is a placeholder fo the branch name). The risk for conflicts at this stage is minimized, if you have [#updatefeaturebranch updated the feature branch] regularly

    * [#sharing share] your feature branch via your user repository
```bash
        git push origin <feature branch>
```

4. notify the system core group (system-core at hirlam.org) and request them to pull from your feature branch into the central public branch `develop`. The request should provide following information:

     * the name of your feature branch

     * indication on whether to gather the feature commits into a single one (squashing into one commit)

   The system-core group will likely include your feature commits by *rebasing* them, in order to clear history for many merge commits, and this will create a new commit history for the feature. However, your original author information including the original author date is still retained.

5. after system-core has published your feature on the public `develop` branch, you can update your local `develop` branch, as well as on your user repository:
```bash
        git checkout develop
        git pull public develop
        git push origin develop
```
    so now your have gotten your feature back in its published form, and your own feature branch has become obsolete.

6. delete your feature branch in order to avoid any confusion in the future (we assume that your feature branch has no other extra commits than those that have been published). Remove it both locally and on your user repository at hirlam.org:
```bash
        git branch -D <feature branch>
        git push origin :<feature branch>
```


----


## Repository Structure

### Branches #branches

The repository structure is basically designed around the [git-flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) ideas, without reflecting it completely. The publicly available Harmonie git repository contains following branches:

 master::
   the harmonie branch for ready releases, HEAD points to latest official release

 develop::
   the general harmonie development branch (reflects mostly the role of the old svn trunk)
   - 
 CY'nn'::
   major development branch for cycle 'nn'
   - 

Branching hierarchy is such that there is one major development branch for each future cycle, and branch `develop` is the ultimate development line, which reflects the development of the currently official Harmonie cycle, and from which all the future cycle branches CY'nn' are to be branched off.

Currently, `develop` reflects the cycle 43 development, so there is no extra CY43 branch. The previously existing CY43 branch has been [merged into `develop`](./SourceCodeRepository/DevelopmentMerge/CY43.md). All history from CY43 has thus entered into `develop`.

For future cycles like for example cycle 46, a branch called CY46 is established. It is going to exist until merged into `develop`.


Any feature development would be meant to branch off from:

  * the `develop` cycle, if the feature relates to the cycle that branch `develop` represents
  * CY'nn', if the feature relates to cycle 'nn'

Each feature branch is supposed to be updated by the branch, from which it was branched off, and to be merged back into that same branch, once the feature is finished.



### Tags

The tags in the Harmonie git repository may originate

  * from the **arpifs** code repository of Meteo France, where they follow the conventions of Meteo France git repository
  * from  Harmonie itself, where they are used to mark releases or other potentially important snapshots. Release tags usually start with prefix "release-" (see below)

Following tag prefix conventions are used in the Harmonie git repository:

  release-::
    identifies a release
  end-::
    identifies the end of a cycle within commit history. The cycle number appears after the prefix. Doing a hard reset to this tag allows to get to that snapshot easily.
  merge-::
    identifies the point in commit history, at which the cycle indicated by the number that follows the prefix has been merged into the develop branch.

## From svn to git

The motivations for migration from svn revision control to git revision control are not discussed here. Instead,
following sketch provides aspects about the procedure of *how* migration is done:

* following svn branches are migrated to git
  1. those parts from major development branch **trunk**, which refer to Harmonie
     * the history of the Harmonie trunk commits is retained in the git repository as much as possible
     * the new name for this branch is *develop*
  2. cycle 43 svn branches that reflect the major development for cycle 43, are gathered into one branch
     * the new name for this branch is CY43


* svn tags are no longer independend branches, they are now embedded as real tags with the development branches

### Date informations

 committer dates::
   - reflect the *original* committer date in case of an original arpifs commit (these *original* committer dates are those dates when arpifs was converted to git
   - reflect an artificial committing date in case of commits from svn trunk, in order to better fit them into the timeline of arpifs commits

 author dates::
   - reflect the *original* author date in case of an original arpifs commit (these *original* author dates are those dates when arpifs was converted to git
   - reflect the original commit date in case of an svn commit

So the author dates are the really important dates for those commits that stem from svn.



### Specific circumstances

There are some things from the svn workflow, that become different with the git repo:

1. The svn barnches harmonie-43t1, harmonie-43t2 and harmonie-43h1.pre-alpha.1 develeopments have been collapsed to the cy43 development branch CY43

1. In svn the release tags where independend branches, and there are tag specific svn commmits to adapt for example the "Default_release" setting in the config-sh/Harmonie script. These adaptations have never entered the trunk in svn. Under git, where we have the master branch for the releases, I have added these tag specific commits at the point of the release, and created a new tag.

This has been done back in history for following releases:


| svn tag branch         | git release tag    |
| --- | --- |
| harmonie-38h1.1        | release-38h1.1     |
| harmonie-40h1.1        | release-40h1.1     |


Here the prefix *release-* is put in front in the git repo, to make them easier to
find in the long list of tags.


So these two releases should be fully reproducable from the git repo by making use of the git release tag.

The svn tag names also still exist, where the svn-git converter has put them, but they don't reflect the svn tag code to 100%.  These svn tags should probably be removed from the git history in order to clear things up.




### Modified History

The history of the svn trunk that concerns Harmonie, could not be taken over to git *as is*. Some svn commits had to be ommitted or where squashed together in order to retain full history within git, or in order to simplify a merge.

On the other hand, merge commits are added into the git history in order to connect history to the **arpifs** code repository. These commits can be identified via the commit message by the leading entry

```bash
mp NN: set merge point
```

where 'NN' is a moving number.


An example of an omitted svn commit is 'r15152'. Including this into git history would breack the *continuous thread* of history for each removed file, which would restrict the usability of for example **git blame**. Instead 'r15154' reflects the full merge:

```bash
2615591095a96b9a78faf334d971d31188f877d0  2016-08-29 07:51:46 +0000   Load c43t1 source.  (cy43t1)
```

Note also the tag cy43t1, that reflects the development w.r.t. *'arpifs*.


And example of squashed svn commits are 'r17136, r17137, r17138, r17139, r17140', which appear under git as:

```bash
7a401b680ca730e4b74c8d2d8604ab59b1132d22  2018-05-25 13:48:57 +0000  Merge trunk/src/arpifs/control.  (43h1.pre-alpha.1)
```



----


