@Library('qloudqa-pipeline-lib@master') import org.com.DitSteps
node {
    acme.setJobName("$JOB_NAME")
    acme.init(BUILD_NUMBER)
    def dit = new org.com.DitSteps(steps)

    currentBuild.result = "SUCCESS"

    def nodeHome = tool 'NodeJS_8.12'

    name_list = "$JOB_NAME".split('/') //eg : 'qloudtest-obptest/master' --> ['qloudtest-obptest', 'master']
    def job = name_list[0]           //eg : 'qloudtest-obptest'
    def ver = name_list[1]           //eg : 'master'
    job_list = "$job".split('-')      //eg : 'qloudtest-obptest' --> ['qloudtest', 'obptest']
    def project = job_list[0]            //eg : 'qloudtest'
    def item = job_list[1]               //eg : 'obptest'
    def itemhttpd = item+'httpd'
    def itemauth = item+'microauth'
    def itemserver = item+'server'
    echo itemserver
    echo '***************************************'
    def taghttpd = "reg.qloudhub.com/'${project}'/'${itemhttpd}':latest'$BUILD_NUMBER'"
    echo taghttpd
    def tagauth = "reg.qloudhub.com/'${project}'/'${itemauth}':latest'$BUILD_NUMBER'"
    echo tagauth
    def tagserver = "reg.qloudhub.com/'${project}'/'${itemserver}':latest'$BUILD_NUMBER'"
    echo tagserver
    echo '***************************************'
    try {
        stage('Check out') {
            checkout scm
        }

       // server 代码构建
       stage('Build') {
		   dir('server-dev'){
			   sh("docker build -t ${tagserver} .")
			   sh("docker push ${tagserver}")
		   }
		}
	   // 推送server chart
	   stage('Send Helm') {
		   dir('chart') {
			   git credentialsId: "hexiang", url: 'https://192.168.11.21/plugins/git/qloudlet/' + "$project" + '-charts.git'
			   def chart_name = 'obptestserver'
			   sh("helm package --version=0.0.1 --app-version=latest'$BUILD_NUMBER' $chart_name")
			   def char_tgz = chart_name + '-' + '0.0.1' + '.tgz'
			   sh("""
						   curl -v --data-binary "@${char_tgz}" http://192.168.72.205:8080/api/charts
				""")
		   }
	   }

	   // microauth 代码构建
	   stage('Build') {
		   withEnv(["PATH+NODE=${ nodeHome }/bin"]) {
			   dir('microauth'){
				  sh "rm -rf node_modules"
				  sh "npm config set registry='http://192.168.11.22:8081/repository/npm-group/'"
				  sh 'npm cache clean --force'
				  sh 'npm install'
				  sh("docker build -t ${tagauth} .")
				  sh("docker push ${tagauth}")
			   }
		   }
	   }

       // 推送microauth chart
	   stage('Send Helm') {
		   dir('chart') {
			   git credentialsId: "hexiang", url: 'https://192.168.11.21/plugins/git/qloudlet/' + "$project" + '-charts.git'
			   def chart_name = 'obptestmicroauth'
			   sh("helm package --version=0.0.1 --app-version=latest'$BUILD_NUMBER' $chart_name")
			   def char_tgz = chart_name + '-' + '0.0.1' + '.tgz'
			   sh("""
						   curl -v --data-binary "@${char_tgz}" http://192.168.72.205:8080/api/charts
				""")
		   }
	   }
	   // httpd 代码构建
	   stage('Build') {
		   dir('httpd'){
			   sh("docker build -t ${taghttpd} .")
			   sh("docker push ${taghttpd}")
		   }
		}

        // 推送 httpd chart
	   stage('Send Helm') {
		   dir('chart') {
			   git credentialsId: "hexiang", url: 'https://192.168.11.21/plugins/git/qloudlet/' + "$project" + '-charts.git'
			   def chart_name = 'obptest'
			   sh("helm package --version=0.0.1 --app-version=latest'$BUILD_NUMBER' $chart_name")
			   def char_tgz = chart_name + '-' + '0.0.1' + '.tgz'
			   sh("""
						   curl -v --data-binary "@${char_tgz}" http://192.168.72.205:8080/api/charts
				""")
		   }
	   }
	   stage('Cleanup') {
			sh("docker rmi ${tagserver}")
			sh("docker rmi ${tagauth}")
			sh("docker rmi ${taghttpd}")
			sh "rm -rf *"
			sh "rm -rf .git"
	   }
    } catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }
}






