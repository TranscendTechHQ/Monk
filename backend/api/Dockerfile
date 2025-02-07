FROM public.ecr.aws/docker/library/python:3.11.8

COPY ./ /backend
COPY requirements.txt /backend
WORKDIR /backend
RUN echo Installing Python packages listed in requirements.txt
RUN pip3 install -r requirements.txt
RUN echo Starting python and starting the FastAPI service...
ENTRYPOINT ["python3"]
CMD ["main.py"]