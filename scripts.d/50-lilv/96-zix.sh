#!/bin/bash

SCRIPT_REPO="https://github.com/drobilla/zix.git"
SCRIPT_COMMIT="18e62483cb7173c6604f7dd2097299e47c2a4c0c"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" zix
    cd zix

    mkdir build && cd build

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=static
        -Ddocs=disabled
        -Dbenchmarks=disabled
        -Dtests=disabled
        -Dtests_cpp=disabled
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --cross-file=/cross.meson
        )
    else
        echo "Unknown target"
        return -1
    fi

    meson "${myconf[@]}" ..
    ninja -j"$(nproc)"
    ninja install
}
