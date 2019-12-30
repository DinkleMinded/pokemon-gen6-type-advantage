// Clear database if needed:
// MATCH (n) DETACH DELETE n

// type_id,local_language_id,name
// 1,1,ノーマル
// 1,3,노말
// 1,5,Normal
// 1,6,Normal
// 1,7,Normal
// 1,8,Normale
// 1,9,Normal

LOAD CSV WITH HEADERS FROM "https://github.com/PokeAPI/pokeapi/raw/master/data/v2/csv/type_names.csv" AS line
CREATE (:Type { TypeId: toInteger(line.type_id), LocalLanguageId: toInteger(line.local_language_id), Name: line.name})

MATCH (n:Type) WHERE n.LocalLanguageId=9 RETURN n

// damage_type_id,target_type_id,damage_factor
// 1,1,100
// 1,2,100
// 1,3,100
// 1,4,100
// 1,5,100
// 1,6,50
// 1,7,100
// 1,8,0
// 1,9,50
// 1,10,100
// 1,11,100
// 1,12,100
// 1,13,100
// 1,14,100
// 1,15,100
// 1,16,100
// 1,17,100
// 1,18,100

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/PokeAPI/pokeapi/master/data/v2/csv/type_efficacy.csv" AS line 
WITH line WHERE line.damage_factor="200"
MATCH (m:Type {TypeId: toInteger(line.damage_type_id)})
MATCH (n:Type {TypeId: toInteger(line.target_type_id)}) WHERE m.LocalLanguageId = n.LocalLanguageId
MERGE (m)-[:BEATS {DamageFactor:toInteger(line.damage_factor)}]->(n)

MATCH p=(n:Type)-[r:BEATS]->() WHERE n.LocalLanguageId =9 RETURN p
