FROM alpine:3.13

RUN apk update                                                                                          && \
    apk upgrade                                                                                         && \
    apk add llvm10-dev llvm10-static clang-dev clang-static g++ git cmake ninja musl-dev python coreutils && \
    git clone -b clang_10 --single-branch https://github.com/include-what-you-use/include-what-you-use.git        && \
    mkdir iwyu                                                                                          && \
    cd iwyu                                                                                             && \
    cmake ../include-what-you-use -DCMAKE_PREFIX_PATH=/usr/lib/cmake/llvm10 -G Ninja -Wno-dev            && \
    ninja install                                                                                       && \
    mkdir -p /usr/local/lib/clang                                                                       && \
    ln -s $(clang -print-resource-dir) $(include-what-you-use -print-resource-dir 2>&-)                 && \
    apk del llvm10-static clang-static git cmake ninja                                                   && \
    rm -rf /iwyu /include-what-you-use

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
