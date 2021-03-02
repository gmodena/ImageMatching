spark_version := 2.4.7
hadoop_version := 2.7
spark_home := spark-${spark_version}-bin-hadoop${hadoop_version}
spark_tgz_url := http://apachemirror.wuchna.com/spark/spark-${spark_version}/${spark_home}.tgz

venv: requirements.txt
	test -d venv || python -m venv venv
	. venv/bin/activate; pip install -Ur requirements.txt;

install_spark:
	test -d ${spark_home} || (wget ${spark_tgz_url}; tar -xzvf ${spark_home}.tgz)

clean_spark:
	rm -r ${spark_home}; rm -rf ${spark_home}.tgz

test:	venv
	. venv/bin/activate; pytest --cov etl tests/
