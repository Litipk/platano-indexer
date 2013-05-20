# run "make help" to display options

# Public config
PROJECT_NAME := platano-indexer
VERSION := 0.5
MAIN_PACKAGE := com.bananity
SRC_DIR := src/
TARGET_DIR := target/
CODE_DIR := main/
CLASS_DIR := classes/
TEST_DIR := test/
TEST_CLASS_DIR := test-classes/
JAVA_DIR := java/
RES_DIR := resources/
DOC_DIR := doc/javadoc/
LIB_DIR := lib/
DIST_DIR := $(TARGET_DIR)
FINAL_NAME := $(PROJECT_NAME)-$(VERSION)
PACKAGE_TYPE := war
PACKAGE_NAME := $(FINAL_NAME).$(PACKAGE_TYPE)
GIT_ORIGIN := https://github.com/Bananity/api.git
README_PRJ := README.prj
WEBAPP_DIR := webapp/
WEBINF_DIR := WEB-INF/
WEB_XML := web.xml
SERVLET_CONF := $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(WEBINF_DIR)$(WEB_XML)
DEPLOYMENT_DIR := /standalone/deployments/
LOG4J_CONF := log4j.properties
JSP_INFO_DIR := server_info/
SERVER_INFO_DIR := $(WEBINF_DIR)$(JSP_INFO_DIR)
REMOTE_SERVER := root@46.105.110.101
REMOTE_DEPLOYMENT_DIR := /opt/jboss/standalone/deployments/
CONF_PROPERTIES := conf.properties
LOCAL_CONF_PROPERTIES := LOCAL_conf.properties
REMOTE_CONF_PROPERTIES := LOCAL_conf.properties

# Deploy config
PUBLISH_SERVER_ADDR := 54.246.173.194
PUBLISH_SERVER_PORT := 2225
PUBLISH_SERVER_KEY := ~/.ec2/certs/bananity-developer.pem

# Private config
RM := rm -rf
JC := javac
JDOC := javadoc
JAR := jar
JARFLAGS := -cf
JCFLAGS := -cp "$(LIB_DIR)*:."
JDOCFLAGS := -classpath "$(LIB_DIR)*:." -quiet -private -use -version -author
JTEST_FLAGS := -cp "$(TARGET_DIR)$(CLASS_DIR):$(LIB_DIR)*:."
TAR_GZ := tar -czvf
TAR_FILE := tar.gz
ZIP := zip -r
ZIP_FILE := zip
TO_CLEAN := $(RM) $(DOC_DIR) $(TARGET_DIR) $(DIST_DIR) *.$(TAR_FILE) *.$(ZIP_FILE)
GIT_IGNORE := .gitignore
MANIFEST := MANIFEST.MF

.PHONY : create gitignore help_file check clean clean_build clean_doc clean_backup compile dist compile_test test doc run edit tar zip help deploy servlet ejb

all: check clean compile dist compile_test test doc

help_file:
	@echo "This project has the following structure:\n\nRoot dir ($(PWD))\n |-$(SRC_DIR)\n | |-$(CODE_DIR)\n | | |-$(JAVA_DIR)   the source code in java packages\n | | |-$(RES_DIR)   resources associated to the code (configuration files, images...)\n | | | \`-$(LOG4J_CONF)   Log4j configuration file\n | | |-$(WEBAPP_DIR)   public JSP's and web pages\n | | | |-$(WEBINF_DIR)   configuration and private JSP's\n | | | | |-$(JSP_INFO_DIR)   JSP's related to HTTP status codes (400, 404, 500...)\n | | \` \` \`-$(WEB_XML)   servlet's configuration\n | |\n | |-$(TEST_DIR)\n | | |-$(JAVA_DIR)   the tests source code in java packages\n | \` \`-$(RES_DIR)   resources associated to the tests (configuration files, images...)\n |  \n |-$(TARGET_DIR)\n | |-$(CLASS_DIR)   java bytecode files (*.class) following the packages structure (see make compile)\n | |-$(TEST_CLASS_DIR)   java bytecode files (*.class) following the packages structure (see make compile_test)\n | \`-$(PACKAGE_NAME)   java archive (see make dist)\n |  \n |-$(LIB_DIR)   dependencies (jar files)\n |\n \`-$(DOC_DIR)   autogenerated documentation (see make doc)\n" > $(README_PRJ)
	@echo ">> Have a quick look to $(README_PRJ) file"

create: help_file gitignore
	@mkdir -p $(SRC_DIR)$(CODE_DIR)$(JAVA_DIR) $(SRC_DIR)$(CODE_DIR)$(RES_DIR) $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(WEBINF_DIR) $(SRC_DIR)$(TEST_DIR)$(JAVA_DIR) $(SRC_DIR)$(TEST_DIR)$(RES_DIR) $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR) $(LIB_DIR)
	@echo ">> Creating index and error pages (JSP) at $(SERVER_INFO_DIR)"
	@echo "<html><head></head><body><h1>Welcome to $(PROJECT_NAME) !!</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)index.jsp
	@echo "<html><head></head><body><h1>400 Bad Request</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)400.jsp
	@echo "<html><head></head><body><h1>401 Unauthorized</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)401.jsp
	@echo "<html><head></head><body><h1>402 Payment Required</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)402.jsp
	@echo "<html><head></head><body><h1>403 Forbidden</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)403.jsp
	@echo "<html><head></head><body><h1>404 Not Found</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)404.jsp
	@echo "<html><head></head><body><h1>405 Method Not Allowed</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)405.jsp
	@echo "<html><head></head><body><h1>406 Not Acceptable</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)406.jsp
	@echo "<html><head></head><body><h1>407 Proxy Authentication Required</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)407.jsp
	@echo "<html><head></head><body><h1>408 Request Timeout</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)408.jsp
	@echo "<html><head></head><body><h1>409 Conflict</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)409.jsp
	@echo "<html><head></head><body><h1>410 Gone</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)410.jsp
	@echo "<html><head></head><body><h1>411 Length Required</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)411.jsp
	@echo "<html><head></head><body><h1>412 Precondition Failed</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)412.jsp
	@echo "<html><head></head><body><h1>413 Request Entity Too Large</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)413.jsp
	@echo "<html><head></head><body><h1>414 Request-URI Too Long</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)414.jsp
	@echo "<html><head></head><body><h1>415 Unsupported Media Type</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)415.jsp
	@echo "<html><head></head><body><h1>416 Requested Range Not Satisfiable</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)416.jsp
	@echo "<html><head></head><body><h1>417 Expectation Failed</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)417.jsp
	@echo "<html><head></head><body><h1>500 Internal Error</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)500.jsp
	@echo "<html><head></head><body><h1>501 Not Implemented</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)501.jsp
	@echo "<html><head></head><body><h1>502 Bad Gateway</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)502.jsp
	@echo "<html><head></head><body><h1>503 Service Unavailable</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)503.jsp
	@echo "<html><head></head><body><h1>504 Gateway Timeout</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)504.jsp
	@echo "<html><head></head><body><h1>505 HTTP Version Not Supported</h1></body></html>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(SERVER_INFO_DIR)505.jsp
	@echo "<!DOCTYPE web-app PUBLIC\n \"-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN\"\n \"http://java.sun.com/dtd/web-app_2_3.dtd\" >\n<web-app>\n\t<display-name>$(PROJECT_NAME)</display-name>\n\t<!-- servlets mapping -->\n\t<servlet>\n\t\t<servlet-name>HelloWorld</servlet-name>\n\t\t<servlet-class>$(MAIN_PACKAGE).HelloWorld</servlet-class>\n\t</servlet>\n\t<servlet-mapping>\n\t\t<servlet-name>HelloWorld</servlet-name>\n\t\t<url-pattern>/hw</url-pattern>\n\t</servlet-mapping>\n\n\t<!-- info pages -->\n\t<error-page>\n\t\t<error-code>400</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)400.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>401</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)401.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>402</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)402.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>403</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)403.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>404</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)404.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>405</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)405.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>406</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)406.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>407</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)407.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>408</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)408.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>409</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)409.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>410</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)410.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>411</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)411.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>412</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)412.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>413</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)413.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>414</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)414.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>415</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)415.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>416</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)416.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>417</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)417.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>500</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)500.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>501</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)501.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>502</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)502.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>503</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)503.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>504</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)504.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<error-code>505</error-code>\n\t\t<location>/$(SERVER_INFO_DIR)505.jsp</location>\n\t</error-page>\n\t<error-page>\n\t\t<exception-type>java.lang.Exception</exception-type>\n\t\t<location>/$(SERVER_INFO_DIR)500.jsp</location>\n\t</error-page>\n</web-app>" > $(SERVLET_CONF)
	@echo ">> Creating dummy Servlet (HelloWorld) at /hw"
	@final_dir=`echo "$(MAIN_PACKAGE)" | sed 's/\./\//g'` && mkdir -p $(SRC_DIR)$(CODE_DIR)$(JAVA_DIR)$$final_dir
	@final_dir=`echo "$(MAIN_PACKAGE)" | sed 's/\./\//g'` && echo "package $(MAIN_PACKAGE);\n\nimport java.io.IOException;\nimport java.io.PrintWriter;\nimport javax.servlet.ServletConfig;\nimport javax.servlet.ServletException;\nimport javax.servlet.http.HttpServlet;\nimport javax.servlet.annotation.WebServlet;\nimport javax.servlet.http.HttpServletRequest;\nimport javax.servlet.http.HttpServletResponse;\n\nimport org.apache.log4j.Logger;\nimport org.apache.log4j.BasicConfigurator;\nimport org.apache.log4j.PropertyConfigurator;\n\n@WebServlet(\"/hw\")\npublic class HelloWorld extends HttpServlet {\n\n\tprivate static Logger log;\n\n\t@Override\n\t\tpublic void init(ServletConfig config) throws ServletException {\n\t\t\tsuper.init(config);\n\t\t\tClassLoader classLoader = Thread.currentThread().getContextClassLoader();\n\t\t\tPropertyConfigurator.configure(classLoader.getResource(\"log4j.properties\"));\n\t\t\tlog = Logger.getLogger(\"HelloWorld\");\n\t\t}\n\n\t@Override\n\t\tpublic void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {\n\t\t\ttry {\n\t\t\t\tresponse.getWriter().println(\"Hello World !!\");\n\t\t\t\tlog.info(\"Hello World !!\");\n\t\t\t} catch (Exception e) {\n\t\t\t\tresponse.setStatus(HttpServletResponse.SC_BAD_REQUEST);\n\t\t\t\tresponse.getWriter().println(\"Exception: \"+e.getMessage());\n\t\t\t}\n\t\t}\n}" > $(SRC_DIR)$(CODE_DIR)$(JAVA_DIR)$$final_dir/HelloWorld.java
	@echo ">> Creating config file for log4j at $(SRC_DIR)$(CODE_DIR)$(RES_DIR) (INFO level)"
	@echo "log4j.rootCategory=INFO,CONSOLA\nlog4j.appender.CONSOLA=org.apache.log4j.ConsoleAppender\nlog4j.appender.CONSOLA.layout=org.apache.log4j.PatternLayout\nlog4j.appender.CONSOLA.layout.ConversionPattern=%-4r [%t] %-5p %c %x - %m%n" > $(SRC_DIR)$(CODE_DIR)$(RES_DIR)$(LOG4J_CONF)
	@echo ">> Project created (remember to add libraries)"

gitignore:
	@if ! test -f "$(GIT_IGNORE)"; then echo ">> Creating $(GIT_IGNORE) file"; echo "$(TARGET_DIR)\n$(DOC_DIR)\n*.$(ZIP_FILE)\n*.$(TAR_FILE)" > $(GIT_IGNORE); fi

check:
	@if ! test -d "$(SRC_DIR)"; then echo "Missing source directory $(SRC_DIR), see 'make create'"; exit 1; fi
	@if ! test -d "$(SRC_DIR)$(CODE_DIR)"; then echo "Missing code directory $(SRC_DIR)$(CODE_DIR), see 'make create'"; exit 1; fi
	@if ! test -d "$(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)"; then echo "Missing webapp directory $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR), see 'make create'"; exit 1; fi
	@if ! test -d "$(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(WEBINF_DIR)"; then echo "Missing web-inf directory $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(WEBINF_DIR), see 'make create'"; exit 1; fi
	@if ! test -d "$(SRC_DIR)$(CODE_DIR)$(JAVA_DIR)"; then echo "Missing java code directory $(SRC_DIR)$(CODE_DIR)$(JAVA_DIR), see 'make create'"; exit 1; fi
	@if ! test -d "$(SRC_DIR)$(TEST_DIR)"; then echo "Missing test directory $(SRC_DIR)$(TEST_DIR), see 'make create'"; exit 1; fi
	@if test "$(JBOSS_HOME)" = "" ; then echo "JBOSS_HOME is undefined"; exit 1; fi

clean: clean_build clean_doc clean_backup

clean_build:
	@$(RM) $(TARGET_DIR)

clean_doc:
	@$(RM) $(DOC_DIR)

clean_backup:
	@$(RM) *.$(TAR_FILE) *.$(ZIP_FILE)

compile: check clean_build
	@echo -n ">> Compiling code..."
	@mkdir -p $(TARGET_DIR)$(CLASS_DIR)
	@$(JC) $(JCFLAGS) -d $(TARGET_DIR)$(CLASS_DIR) `find $(SRC_DIR)$(CODE_DIR)$(JAVA_DIR) -name *.java`
	@if test -d "$(SRC_DIR)$(CODE_DIR)$(RES_DIR)"; then if test `ls $(SRC_DIR)$(CODE_DIR)$(RES_DIR) | wc -l` -gt 0; then cp -r $(SRC_DIR)$(CODE_DIR)$(RES_DIR)* $(TARGET_DIR)$(CLASS_DIR); fi; fi
	@echo " Ben jugat (^o^)/"

compile_test: dist
	@echo ">> Compiling test"
	@mkdir -p $(TARGET_DIR)$(TEST_CLASS_DIR)
	@$(JC) $(JTEST_FLAGS) -d $(TARGET_DIR)$(TEST_CLASS_DIR) `find $(SRC_DIR)$(TEST_DIR)$(JAVA_DIR) -name *.java`
	@if test -d "$(SRC_DIR)$(TEST_DIR)$(RES_DIR)"; then if test `ls $(SRC_DIR)$(TEST_DIR)$(RES_DIR) | wc -l` -gt 0; then cp -r $(SRC_DIR)$(TEST_DIR)$(RES_DIR)* $(TARGET_DIR)$(TEST_CLASS_DIR); fi; fi

test: compile_test
	@echo ">> Testing"
	@for test_file in `cd $(TARGET_DIR)$(TEST_CLASS_DIR) ; find . -name "*Test.class" | awk '{path = substr($$0,3,length($$0)-8); gsub(/\//,".",path); print path;}'` ; do \
		echo Testing: $$test_file ; \
		if test "$$i" = "" ; then cd $(TARGET_DIR)$(TEST_CLASS_DIR); fi; \
		output=`java -cp "../../$(LIB_DIR)*:../$(CLASS_DIR):." org.junit.runner.JUnitCore $$test_file` ; \
		echo "$$output" ; \
		if test `echo $$output | grep "FAILURES!!!" | wc -l` -gt 0; then exit 1; fi; \
		i=`expr $$i + 1`; \
	done

coverage_report:
	java -cp .:lib/*:target/classes/:target/test-classes/ org.pitest.mutationtest.MutationCoverageReport --reportDir coverageReport --targetClasses com.bananity.* --sourceDirs src/main/ --targetTests com.bananity.* --threads 4

dist: compile
	@echo ">> Packaging ($(PACKAGE_TYPE))"
	@mkdir $(TARGET_DIR)$(FINAL_NAME)/
	@cp -r $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)* $(TARGET_DIR)$(FINAL_NAME)/
	@cp -r $(LIB_DIR) $(TARGET_DIR)$(FINAL_NAME)/$(WEBINF_DIR)
	@cp -r $(TARGET_DIR)$(CLASS_DIR) $(TARGET_DIR)$(FINAL_NAME)/$(WEBINF_DIR)
	$(if $(filter "$(MAKECMDGOALS)", "remote_deploy"), @echo "Using REMOTE configuration";cp -r $(SRC_DIR)$(CODE_DIR)$(RES_DIR)$(REMOTE_CONF_PROPERTIES) $(TARGET_DIR)$(CLASS_DIR)$(CONF_PROPERTIES);cp -r $(SRC_DIR)$(CODE_DIR)$(RES_DIR)$(REMOTE_CONF_PROPERTIES) $(TARGET_DIR)$(FINAL_NAME)/$(WEBINF_DIR)$(CLASS_DIR)$(CONF_PROPERTIES);, $(if $(filter "$(MAKECMDGOALS)", "local_deploy"), @echo "Using LOCAL configuration";cp -r $(SRC_DIR)$(CODE_DIR)$(RES_DIR)$(LOCAL_CONF_PROPERTIES) $(TARGET_DIR)$(CLASS_DIR)$(CONF_PROPERTIES);cp -r $(SRC_DIR)$(CODE_DIR)$(RES_DIR)$(LOCAL_CONF_PROPERTIES) $(TARGET_DIR)$(FINAL_NAME)/$(WEBINF_DIR)$(CLASS_DIR)$(CONF_PROPERTIES);, @echo "Using DEFAULT (local) configuration";cp -r $(SRC_DIR)$(CODE_DIR)$(RES_DIR)$(LOCAL_CONF_PROPERTIES) $(TARGET_DIR)$(CLASS_DIR)$(CONF_PROPERTIES);cp -r $(SRC_DIR)$(CODE_DIR)$(RES_DIR)$(LOCAL_CONF_PROPERTIES) $(TARGET_DIR)$(FINAL_NAME)/$(WEBINF_DIR)$(CLASS_DIR)$(CONF_PROPERTIES);))
	@cd $(DIST_DIR)/; echo "Manifest-Version: 1.0\nCreated-By: Alberto Rubio\nClass-Path: WEB-INF/classes/\n" > $(MANIFEST)
	@cd $(TARGET_DIR)$(FINAL_NAME)/; $(JAR) $(JARFLAGS) $(PACKAGE_NAME) *; mv $(PACKAGE_NAME) ../../$(DIST_DIR)

doc: clean_doc
	@echo ">> Documentation"
	@mkdir -p $(DOC_DIR)
	@$(JDOC) $(JDOCFLAGS) -d $(DOC_DIR) `find $(SRC_DIR)$(CODE_DIR)$(JAVA_DIR) -name *.java`

pull:
	@git pull

push: test clean gitignore pull
	@#@$(TO_CLEAN)
	git commit -am "$(m)"
	git push $(GIT_ORIGIN) $(b)

local_deploy: dist
	@rm -f $(JBOSS_HOME)$(DEPLOYMENT_DIR)$(FINAL_NAME)*
	@cp $(TARGET_DIR)$(PACKAGE_NAME) $(JBOSS_HOME)$(DEPLOYMENT_DIR)
	@touch $(JBOSS_HOME)$(DEPLOYMENT_DIR)$(FINAL_NAME).dodeploy
	@echo -n ">> Deployed at localhost "
	@if test `ps aux | grep "org.jboss.as" | grep -v "grep" | wc -l` -gt 0 ; then echo "(and running)"; else echo "(but NOT running)"; fi

remote_deploy: dist
	@scp -C -P $(PUBLISH_SERVER_PORT) -i $(PUBLISH_SERVER_KEY) $(DIST_DIR)$(PACKAGE_NAME) developer@$(PUBLISH_SERVER_ADDR):publish/$(PACKAGE_NAME)
	@ssh -C -p $(PUBLISH_SERVER_PORT) -i $(PUBLISH_SERVER_KEY) developer@$(PUBLISH_SERVER_ADDR) 'sudo ./btydeploy'

edit:
	@if test "$$n" = "" ; then vim -p `find -name "*.java"`; else vim -p `find . -name *.java -type f -exec ls -lt --full-time \{\} + | awk '{print $$6$$7" "$$9; }' - | sort -r | head -$$n | awk '{print $$2;}' -`; fi

servlet:
	@if test "$(p)" = "" ; then echo "Package (ie. "com.bananity.controller") is undefined. Usage: make servlet p=<PACKAGE.NAME> u=<URL_PATH> c=<CLASS_NAME>"; exit 1; fi
	@if test "$(u)" = "" ; then echo "URL Path (ie. "ex") is undefined. Usage: make servlet p=<PACKAGE.NAME> u=<URL_PATH> c=<CLASS_NAME>"; exit 1; fi
	@if test "$(c)" = "" ; then echo "Class name (ie. "Example") is undefined. Usage: make servlet p=<PACKAGE.NAME> u=<URL_PATH> c=<CLASS_NAME>"; exit 1; fi
	@if test `cat $(SERVLET_CONF) | grep "<\!-- servlets mapping -->" | wc -l ` != 1 ; then echo "Cannot find <!-- servlets mapping --> tag in $(SERVLET_CONF) (see make create)"; exit 1; fi
	@final_dir=`echo "$(p)" | sed 's/\./\//g'` && mkdir -p $(SRC_DIR)$(CODE_DIR)$(JAVA_DIR)$$final_dir
	@final_dir=`echo "$(p)" | sed 's/\./\//g'` && echo "package $(p);\n\nimport java.io.IOException;\nimport java.io.PrintWriter;\nimport javax.ejb.EJB;\nimport javax.servlet.ServletConfig;\nimport javax.servlet.ServletException;\nimport javax.servlet.http.HttpServlet;\nimport javax.servlet.annotation.WebServlet;\nimport javax.servlet.http.HttpServletRequest;\nimport javax.servlet.http.HttpServletResponse;\n\nimport org.apache.log4j.Logger;\nimport org.apache.log4j.BasicConfigurator;\nimport org.apache.log4j.PropertyConfigurator;\n\n@WebServlet(\"/$(u)\")\npublic class $(c) extends HttpServlet {\n\n\tprivate static Logger log;\n\n\t@Override\n\t\tpublic void init(ServletConfig config) throws ServletException {\n\t\t\tsuper.init(config);\n\t\t\tClassLoader classLoader = Thread.currentThread().getContextClassLoader();\n\t\t\tPropertyConfigurator.configure(classLoader.getResource(\"log4j.properties\"));\n\t\t\tlog = Logger.getLogger($(c).class);\n\t\t}\n\n\t@Override\n\t\tpublic void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {\n\t\t\ttry {\n\t\t\t\tresponse.getWriter().println(\"Hello World $(c) !!\");\n\t\t\t\tlog.info(\"Hello World $(c) !!\");\n\t\t\t\t//request.setAttribute("view_param", VARIABLE);\n\t\t\t\t//getServletConfig().getServletContext().getRequestDispatcher("/WEB-INF/$$final_dir/PAGINA.jsp").forward(request,response);\n\t\t\t} catch (Exception e) {\n\t\t\t\tresponse.setStatus(HttpServletResponse.SC_BAD_REQUEST);\n\t\t\t\tresponse.getWriter().println(\"Exception: \"+e.getMessage());\n\t\t\t}\n\t\t}\n}" > $(SRC_DIR)$(CODE_DIR)$(JAVA_DIR)$$final_dir/$(c).java;
	@sed -i 's#<!-- servlets mapping -->#<!-- servlets mapping -->\n\t<servlet>\n\t\t<servlet-name>$(c)<\/servlet-name>\n\t\t<servlet-class>$(p).$(c)<\/servlet-class>\n\t<\/servlet>\n\t<servlet-mapping>\n\t\t<servlet-name>$(c)<\/servlet-name>\n\t\t<url-pattern>\/$(u)<\/url-pattern>\n\t<\/servlet-mapping>\n#' $(SERVLET_CONF)
	@echo ">> Servlet $(c) created in package: $(p) with URL path $(u)"

ejb:
	@if test "$(p)" = "" ; then echo "Package (ie. "com.bananity.model") is undefined. Usage: make ejb p=<PACKAGE.NAME> c=<CLASS_NAME>"; exit 1; fi
	@if test "$(c)" = "" ; then echo "Class name (ie. "Example") is undefined. Usage: make ejb p=<PACKAGE.NAME> c=<CLASS_NAME>"; exit 1; fi
	@final_dir=`echo "$(p)" | sed 's/\./\//g'` && mkdir -p $(SRC_DIR)$(CODE_DIR)$(JAVA_DIR)$$final_dir
	@final_dir=`echo "$(p)" | sed 's/\./\//g'` && echo "package $(p);\n\n// Bean Setup\nimport javax.ejb.EJB;\nimport javax.ejb.Startup;\nimport javax.ejb.Singleton;\nimport javax.annotation.PostConstruct;\n\n// Concurrency Management\nimport javax.ejb.Lock;\nimport javax.ejb.LockType;\nimport javax.ejb.DependsOn;\nimport javax.ejb.ConcurrencyManagement;\nimport javax.ejb.ConcurrencyManagementType;\n\n// Timeouts\nimport javax.ejb.AccessTimeout;\nimport javax.ejb.ConcurrentAccessTimeoutException;\n\n// Log4j\nimport org.apache.log4j.Logger;\nimport org.apache.log4j.BasicConfigurator;\nimport org.apache.log4j.PropertyConfigurator;\n\n@Startup\n@Singleton\n//@DependsOn({""})\n@AccessTimeout(value=10000)\n@ConcurrencyManagement(ConcurrencyManagementType.CONTAINER)\npublic class $(c) {\n\n\tprivate static Logger log;\n\n\t@Lock(LockType.READ)\n\t@PostConstruct\n\t\tvoid init() {\n\t\t\tClassLoader classLoader = Thread.currentThread().getContextClassLoader();\n\t\t\tPropertyConfigurator.configure(classLoader.getResource(\"log4j.properties\"));\n\t\t\tlog = Logger.getLogger($(c).class);\n\t\t}\n\n}" > $(SRC_DIR)$(CODE_DIR)$(JAVA_DIR)$$final_dir/$(c).java;
	@echo ">> EJB $(c) created in package: $(p)"

jsp:
	@if test "$(p)" = "" ; then echo "Package (ie. "com.bananity.model") is undefined. Usage: make jsp p=<PACKAGE.NAME> n=<JSP_NAME>"; exit 1; fi
	@if test "$(n)" = "" ; then echo "Name (ie. "view") is undefined. Usage: make jsp p=<PACKAGE.NAME> n=<JSP_NAME>"; exit 1; fi
	@final_dir=`echo "$(p)" | sed 's/\./\//g'` && mkdir -p $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(WEBINF_DIR)$$final_dir
	@final_dir=`echo "$(p)" | sed 's/\./\//g'` && echo "<%@ page import=\"java.util.ArrayList\" %>\n<%\nresponse.setContentType(\"application/json\");\nresponse.setCharacterEncoding(\"UTF-8\");\nArrayList<String> param = (ArrayList<String>)request.getAttribute(\"view_param\");\nout.print(\"[\");\nint size = param.size();\nfor (int i = 0; i < size; i++) {\n\tout.print(param.get(i).toString());\n\tif (i < size-1) {\n\t\tout.print(\",\");\n\t}\n}\nout.print(\"]\");\n%>" > $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(WEBINF_DIR)$$final_dir/$(n).jsp;
	@final_dir=`echo "$(p)" | sed 's/\./\//g'` && echo ">> Private JSP $(n).jsp created in folder: $(SRC_DIR)$(CODE_DIR)$(WEBAPP_DIR)$(WEBINF_DIR)$$final_dir/"

tar: clean
	@echo "Adding to $(FINAL_NAME).$(TAR_FILE):"
	@$(TAR_GZ) $(FINAL_NAME).$(TAR_FILE) *

zip: clean
	@echo "Adding to $(FINAL_NAME).$(ZIP_FILE):"
	@$(ZIP) $(FINAL_NAME).$(ZIP_FILE) *

jboss_start:
	@$(JBOSS_HOME)/bin/standalone.sh -b 0.0.0.0

jboss_stop:
	@ps aux | grep "jboss" | grep -v "grep" | awk '{system("kill -9 "$$2" &> /dev/null");}' - &> /dev/null
	@echo ">> JBOSS Stopped"

help:
	@echo "Usage:"
	@echo " - make: almost everything (check, compile, test, package and documentation)"
	@echo " - make create: creates the basic structure and config files"
	@echo " - make help_file: creates a $(README_PRJ) file describing its structure"
	@echo " - make check: checks requeriments (directories, environment variables...)"
	@echo " - make clean: removes everything except source code"
	@echo " - make clean_build: cleans binary files"
	@echo " - make clean_doc: cleans documentation"
	@echo " - make clean_doc: cleans documentation"
	@echo " - make compile: the source code"
	@echo " - make compile_test: test source code"
	@echo " - make test: runs tests"
	@echo " - make dist: creates the JAR file"
	@echo " - make doc: generates project documentation"
	@echo " - make push [b=<branch>]: runs checks before doing push, where b (the branch to push) is optional. It creates $(GIT_IGNORE) if it does not exist"
	@echo " - make deploy: into local JBoss AS"
	@echo " - make remote_deploy: into remote JBoss AS"
	@echo " - make servlet p=<PACKAGE.NAME> u=<URL_PATH> c=<CLASS_NAME>: creates the <c> Java Servlet in <p> package at <u> URL path"
	@echo " - make ejb p=<PACKAGE.NAME> c=<CLASS_NAME>: creates the <c> Java Bean in <p> package"
	@echo " - make jsp p=<PACKAGE.NAME> n=<JSP_NAME>: creates <n> as a private JSP following the <p> structure"
	@echo " - make edit [n=<#_of_recent_files>]: opens all (or n) source files for editing in VIM (Not Available in MacOS)"
	@echo " - make tar: creates a $(TAR_FILE) file from this project in root directory (after cleaning)"
	@echo " - make zip: creates a $(ZIP_FILE) file from this project in root directory (after cleaning)"
	@echo " - make jboss_start: starts JBoss AS (localhost)"
	@echo " - make jboss_stop: stops JBoss AS (all instances in localhost)"
	@echo " - make help: me again !!"
