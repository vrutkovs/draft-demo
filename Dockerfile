FROM fedora:27

RUN dnf update -y && \
    dnf install -y python3-aiohttp && \
    dnf clean all

RUN mkdir /code
ADD . /code
EXPOSE 8080
CMD ["python3", "/code/server.py"]
