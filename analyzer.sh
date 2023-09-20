#!/bin/bash

#charger le nom
cat "./bin/name.txt"

#installer les dépendances si nécessaire
install_dependencies=""
help=""
install_dependencies_specified=false
help_specified=false

#traiter les arguments
for arg in "$@"; do
  if [[ "$arg" == "--help" ]]; then
    help_specified=true
  elif [[ "$help_specified" == true ]]; then
    help="$arg"
    help_specified=false
  elif [[ "$arg" == "--install_dependencies" ]]; then
    install_dependencies_specified=true
  elif [[ "$install_dependencies_specified" == true ]]; then
    install_dependencies="$arg"
    install_dependencies_specified=false
  elif [[ "$arg" == "--quality_control" ]]; then
      quality_control_specified=true
  elif [[ "$quality_control_specified" == true ]]; then
    quality_control="$arg"
    quality_control_specified=false
  fi
done

if [ "$help_specified" == true ]; then
  cat "./bin/help.txt"
  exit 0
fi
if [ "$install_dependencies_specified" == true ]; then
  echo "Dependencies installation ............................. 0%"
  bash "./modules/install_dependencies.sh"
  echo -e "\033[1ADependencies installation ............................. 100%"
fi

#check si les dépendences sont bien installées
dependencies_file="./bin/dependencies_list.txt"
while IFS= read -r dep; do
    if [ "$dep" = "end" ]; then
        break
    fi
    if conda list -n "$dep" | grep -q "$dep"; then
        echo "$dep is well installed."
    else
        echo "$dep is not installed."
        exit 1
    fi
done < "$dependencies_file"
echo -e "All the dependencies have been checked.\n"

#début des analyses
echo -e "Beginning of analysis."
#télécharger ou importer les données
bash "./modules/download_data.sh" "$@"
#trimmer les données
bash "./modules/clean_fastq.sh"
#contrôle qualité des fastq
if [ "$quality_control" == true ]; then
  bash "./modules/quality_control.sh"
fi