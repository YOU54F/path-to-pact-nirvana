# ./pact_helper.sh doctor
# ./pact_helper.sh install-pact-cli docker
# ./pact_helper.sh uninstall-pact-cli docker
# ./pact_helper.sh install-pact-cli ruby
# ./pact_helper.sh uninstall-pact-cli ruby
# ./pact_helper.sh install-pact-cli standalone
# ./pact_helper.sh uninstall-pact-cli standalone

PACT_CLI_STANDALONE_VERSION=1.89.00

PACT_BIN_PATH=${PACT_BIN_PATH:-'./pact/bin/'}

case $(uname -sm) in
'Linux x86_64')
    os='linux-x86_64'
    ;;
'Darwin x86' | 'Darwin x86_64' | 'Darwin arm64')
    os='osx'
    ;;
'Windows')
    os='win32'
    ;;
esac

case "$1" in
install-pact-cli)
    case $2 in

    'standalone')
        tag=$(basename $(curl -fs -o/dev/null -w %{redirect_url} https://github.com/pact-foundation/pact-ruby-standalone/releases/latest))
        filename="pact-${tag#v}-${os}.tar.gz"
        curl -LO https://github.com/pact-foundation/pact-ruby-standalone/releases/download/${tag}/${filename}
        case $os in
        'linux-x86_64' | 'osx')
            tar xzf ${filename}
            ;;
        'win32')
            unzip ${filename}
            ext=.bat
            ;;
        esac
        rm ${filename}
        ./pact/bin/pact-broker$ext help
        ;;
    'docker')
        docker pull pactfoundation/pact-cli:latest
        docker run --rm \
            -e PACT_BROKER_BASE_URL \
            -e PACT_BROKER_TOKEN \
            pactfoundation/pact-cli:latest \
            pact-broker help
        ;;
    'ruby')
        gem install pact_broker-client
        pact-broker help
        ;;
    *)
        echo "provide a value, standalone, docker or ruby"
        ;;
    esac
    ;;
uninstall-pact-cli)
    case $2 in
    'standalone')
        case $os in
        'linux-x86_64' | 'osx')
            rm -rf pact

            exit
            ;;
        'win32')
            rm -rf pact

            exit
            ;;
        esac
        ;;
    'docker')
        docker image rm pactfoundation/pact-cli

        exit
        ;;
    'ruby')
        gem uninstall -aIx pact_broker-client
        exit
        ;;
    esac
    ;;
doctor)
    echo "We are checking if the pact-broker command is available"
    if ! command -v pact-broker &>/dev/null; then
        echo "pact-broker could not be found on \$PATH"
        echo "trying on \$PACT_BIN_PATH"
        if ! command -v ${PACT_BIN_PATH}pact-broker &>/dev/null; then
            echo "pact-broker could not be found on \$PACT_BIN_PATH"
            echo "Try setting the path to your pact binaries eg PACT_BIN_PATH=./pact/bin/"
            echo "trying to find docker"
            if ! command -v docker &>/dev/null; then
                echo "docker is not found"
                echo "you can install via install-pact-cli docker|ruby|standalone"
            else
                echo "Docker is installed. try install-pact-cli docker, which will perform the following"
                echo "docker pull pactfoundation/pact-cli:latest"
                echo "docker run --rm pactfoundation/pact-cli:latest pact-broker"
                # docker run --rm pactfoundation/pact-cli:latest pact-broker
            fi
            if ! command -v ruby &>/dev/null; then
                echo "ruby is not found"
                echo "Ruby is not installed. try install-pact-cli standalone"
            else
                echo "Ruby is installed. try install-pact-cli ruby"
            fi
            if ! echo $os &>/dev/null; then
                echo "we cant detect your OS"
                echo "try installing pact-ruby-standalone manually"
            else
                echo "We can detect your OS. try install-pact-cli standalone"
            fi
        else
            echo "Hooray! pact-broker command is available under ${PACT_BIN_PATH}pact-broker"
            ${PACT_BIN_PATH}pact-broker
        fi
    else
        echo "Hooray! pact-broker command is available globally!"
        pact-broker
    fi
    ;;

*)
    echo "\n========== STAGE: Not found! Uh Oh ==========\n"

    echo please provide a valid value, try can-i-deploy or publish_provider_contract

    ;;
esac
