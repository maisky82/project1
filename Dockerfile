# 1. 빌드 단계 (debian 기반으로 glibc 버전 일치)
FROM debian:bullseye-slim AS builder

# 필수 패키지 설치 (gcc, git)
RUN apt-get update && apt-get install -y git gcc make && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# GitHub repo clone
RUN git clone https://github.com/jongchank/calc.git src

WORKDIR /app/src

# arithmetic.c 생성 (헤더 포함)
RUN echo '#include "arithmetic.h"\n\
int add(int a,int b){return a+b;}\n\
int sub(int a,int b){return a-b;}\n\
int mul(int a,int b){return a*b;}\n\
int dur(int a,int b){return b==0?0:a/b;}' > ./inc/arithmetic.c

# 컴파일
RUN gcc -I./inc cal_main.c ./inc/arithmetic.c -o calc

# 2. 실행 단계 (같은 debian 기반)
FROM debian:bullseye-slim

# 실행 파일 복사
COPY --from=builder /app/src/calc /usr/local/bin/calc

# ENTRYPOINT: 실행파일 고정
ENTRYPOINT ["/usr/local/bin/calc"]

# CMD: 기본 인자 0 0
CMD ["0", "0"]

