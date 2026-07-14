pipeline {
  agent {
    label '<label in jenkins agent>'
  }
  environment {
    appUser = ""
    appName = ""
    appVersion = ""
    appType = ""
    processName = "${appName}-${appVersion}.${appType}"
    folderDeploy = "/app/${appUser}"
    buildScript = "mvn clean install -DskipTests=true"
    copyScript = "sudo cp target/${processName} ${folderDeploy}"
    permsScript = "sudo chown -R ${appUser}. ${folderDeploy}
    killScript = "sudo kill -9 \$(ps -ef | grep ${processName} | grep -v grep | awk '{print \$2}')"
    runScript = 'sudo su ${appUser} -c "cd ${folderDeploy}; java -jar ${processName} > nohub.out 2>&1 &"'
  }
  stages {
    stage('build') {
      steps {
        sh(script: """ ${buildScript} """, label: "build with maven")
      }
    }
    stage('deploy') {
      steps {
        sh(script: """ ${copyScript} """, label: "copy .jar file into deploy folder")
        sh(script: """ ${permsScript} """, label: "set permission folder")
        sh(script: """ ${killScript} """, label: "terminate the running process")
        sh(script: """ ${runScript} """, label: "run the project)
      }
    }
  }
}