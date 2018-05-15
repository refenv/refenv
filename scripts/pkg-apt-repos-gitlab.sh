#!/usr/bin/env bash

apt-get -yq install software-properties-common curl && \
curl -sL https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash && \
echo "# DONE"; echo "# RES: $?"

cat > /etc/apt/preferences.d/pin-gitlab-runner.pref <<EOF
Explanation: Prefer GitLab provided packages over the Debian native ones
Package: gitlab-runner
Pin: origin packages.gitlab.com
Pin-Priority: 1001
EOF

apt-get -yq update
