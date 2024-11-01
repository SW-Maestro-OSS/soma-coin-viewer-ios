
USER_NAME = $(shell python3 Scripts/author_name.py)
CURRENT_DATE = $(shell pipenv run python Scripts/current_date.py)


Module:
	@mkdir -p Projects/Features/${name};
	@tuist scaffold Module \
	--name ${name} \
	--author "$(USER_NAME)" \
	--current-date "$(CURRENT_DATE)";
	@rm Pipfile >/dev/null 2>&1;
	@tuist edit
