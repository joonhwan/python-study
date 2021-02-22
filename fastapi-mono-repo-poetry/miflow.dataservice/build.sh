rm -rf .bundle 
mkdir .bundle
poetry export -o .bundle/requirements.txt
# 아래같은 local dependency는 pip install 이 안된다 -,.- 일단, pip install 이 아니라 파일복사로 해결하자 -,.-
# miflow.common @ /home/jhlee/prj/study/python/fastapi-monorepo-test python_version >= "3.7" and python_version < "4.0" 
sed -r 's/^(.*@.*)$/# \1/g' .bundle/requirements.txt > .bundle/requirements-non-local.txt
pip install -r .bundle/requirements-non-local.txt --target .bundle/site-packages
echo "finished pip install."
# 의존적 local 프로젝트 코드
echo "copying local projects to site-packages..."
cp -r -t .bundle/site-packages ../miflow.common/src/*
cp -r -t .bundle/site-packages ../miflow.util/src/*

# 현재 프로젝트 코드
cp -r -t .bundle/site-packages ./src/*
mkdir -p dist
poetry run shiv --site-packages .bundle/site-packages --compressed -p '/usr/bin/env python3' -o dist/miflow.dataservice -e 'miflow.dataservice.main:main'
chmod a+x dist/miflow.dataservice