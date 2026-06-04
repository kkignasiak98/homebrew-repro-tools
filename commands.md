brew audit --strict --new kkignasiak98/repro-tools/container-diffoscope

brew fetch -d -v kkignasiak98/repro-tools/container-diffoscope

brew install --build-from-source kkignasiak98/repro-tools/container-diffoscope

brew list | grep container-diffoscope

brew test kkignasiak98/repro-tools/container-diffoscope

## Some tests