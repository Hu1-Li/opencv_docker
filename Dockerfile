FROM python:3.8-slim

RUN set -x; apt-get update && apt-get install -y cron gifsicle && rm -rf /var/lib/apt/lists/* && apt-get -qq autoremove && apt-get -qq clean && pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple && pip install --no-cache-dir opencv_python_headless==4.8.1.78 Pillow==10.1.0 black==23.9.1 python-dotenv==1.0.0 PyYAML==6.0.1 pyftpdlib==1.5.8 imageio==2.31.5 orjson==3.9.9 pydantic==2.4.2 confluent_kafka==2.2.0 requests==2.31.0 minio==7.1.17 && pip install --no-cache-dir torch==2.0.1+cpu torchvision==0.15.2+cpu --index-url https://download.pytorch.org/whl/cpu && pip cache purge

