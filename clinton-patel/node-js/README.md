# node-js
Node JS Sample Application

Process to follow for Continuous Integration in Development Environment:-
1. Clone the git repo:-
   $ git clone git@github.com:clinton-patel/node-js.git
2. Do the fresh checkout of main branch:-
   $ git checkout main
   $ git pull
3. Create the feature branch by following the naming convention:-
   $ git checkout -b feature/<branch name>
4. Do the code changes in feature/<branch name> branch.
5. Raise a PR to merge the code from feature/<branch name> to main branch by putting atleast two persons as a reviewers.
6. Merge the PR in main branch upon successful appoval of PR.
7. Continuous Integration Github Action workflow will be initiated on successful PR merge.
