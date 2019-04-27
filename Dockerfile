FROM rust:slim

# gcc and clang are necessary to be able to compile crates that have build scripts
# Most notably, clang 8 has WASM support enabled by default.
RUN echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" > /etc/apt/sources.list.d/llvm.list
RUN echo "deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" >> /etc/apt/sources.list.d/llvm.list
RUN apt-get update && apt-get install -y --allow-unauthenticated curl gcc make libssl-dev pkg-config clang-8
RUN ln -s /usr/bin/clang-8 /usr/bin/clang

RUN rustup target add asmjs-unknown-emscripten
RUN rustup target add wasm32-unknown-emscripten
RUN rustup target add wasm32-unknown-unknown

RUN rustup toolchain install nightly
RUN rustup target add --toolchain nightly asmjs-unknown-emscripten
RUN rustup target add --toolchain nightly wasm32-unknown-emscripten
RUN rustup target add --toolchain nightly wasm32-unknown-unknown

RUN cargo install cargo-web
RUN cargo install wasm-pack
RUN cargo web prepare-emscripten

COPY config /root/.cargo
COPY asmjs-emscripten-toolchain.cmake /root
