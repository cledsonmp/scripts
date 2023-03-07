#!/bin/bash

# Extrair todas as tags "profile" dentro de "profiles"
profile_tags=$(grep -oP '<profile\s+name="full-ha[^"]{9,}"' domain-teste.xml)

# Iterar por todas as tags de perfil encontradas e extrair informações sobre as datasources
messages=()
for profile in $profile_tags; do
  jndi_name=$(grep -oP '<profile name="'$profile'".*?<datasource jta="true" jndi-name="\K[^"]+' domain-teste.xml | head -1)
  if [ -z "$jndi_name" ]; then
    messages+=("$profile não tem um datasource com jndi-name definido")
  else
    messages+=("$profile tem um datasource com jndi-name $jndi_name")
  fi
done

# Exibir as mensagens na tela
echo "Número de perfis encontrados: $(echo "$profile_tags" | wc -w)"
for message in "${messages[@]}"; do
  echo "$message"
done

