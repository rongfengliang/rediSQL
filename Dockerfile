FROM rustlang/rust:nightly AS build

WORKDIR /app

COPY . /app

RUN rustup --version
RUN rustup install nightly-2019-05-14 && \
    rustup default nightly-2019-05-14

RUN rustc --version && \
    rustup --version && \
    cargo --version

RUN cargo clean && cargo build --release


FROM redis:latest

# RUN apk update; apk add libgcc_s.so.1

COPY  --from=build  /app/target/release/libredis_sql.so /usr/local/lib/libredis_sql.so

EXPOSE 6379

CMD ["redis-server", "--loadmodule", "/usr/local/lib/libredis_sql.so"]
