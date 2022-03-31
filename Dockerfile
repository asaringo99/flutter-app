FROM ubuntu:20.04

WORKDIR /workdir

ARG DART_VERSION=2.13.0
RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && apt-get install -y --no-install-recommends tzdata && \
    apt-get update && \
    apt-get install -y --no-install-recommends bash ca-certificates clang cmake curl file git libglu1-mesa libgtk-3-dev ninja-build pkg-config unzip xz-utils zip && \
    curl https://storage.googleapis.com/dart-archive/channels/stable/release/$DART_VERSION/sdk/dartsdk-linux-x64-release.zip -o /tmp/dart-sdk.zip && \
    unzip /tmp/dart-sdk.zip -d /usr/lib && rm /tmp/dart-sdk.zip

ARG PATH=/usr/lib/dart-sdk/bin:$PATH
ARG PATH=/root/.pub-cache/bin:$PATH
ARG FLUTTER_VERSION=2.2.0
RUN dart pub global activate fvm --verbose && \
    fvm doctor --verbose && \
    fvm install $FLUTTER_VERSION --verbose && \
    fvm use --force $FLUTTER_VERSION --verbose && \
    fvm flutter config --enable-web --enable-linux-desktop --enable-macos-desktop --enable-windows-desktop --enable-android --enable-ios --enable-fuchsia && \
    # fvm flutter precache --verbose && \
    fvm flutter doctor --verbose

# Clean up
RUN apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Set paths
ENV FVM_ROOT=/root/.pub-cache
ENV PATH $FVM_ROOT/bin:$PATH