FROM microsoft/dotnet:2.1-sdk

# node, yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs && \
    apt-get install -y build-essential && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn

# mono
RUN apt install apt-transport-https dirmngr && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/debian stable-stretch main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt update && \
    apt install -y mono-devel

# java
RUN apt-get update && apt-get install zip unzip && \
    curl -s "https://get.sdkman.io" | bash && \
    /bin/bash -c "source $HOME/.sdkman/bin/sdkman-init.sh; sdk install java;"
ENV PATH=$PATH:/root/.sdkman/candidates/java/current/bin

# android
RUN apt-get install -y lib32stdc++6 lib32z1
ENV ANDROID_SDK_VERSION 4333796
RUN mkdir -p /opt/android-sdk && cd /opt/android-sdk && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip && \
    unzip *tools*linux*.zip && \
    rm *tools*linux*.zip
ENV ANDROID_HOME /opt/android-sdk
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
RUN $ANDROID_HOME/tools/bin/sdkmanager  "platforms;android-27" "build-tools;23.0.1" "extras;google;m2repository" "extras;android;m2repository"
