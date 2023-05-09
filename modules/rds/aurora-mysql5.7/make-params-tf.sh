#
#
#
cd $(dirname $0)

file=params.tf
family=$(grep -w family main.tf | head -1 | awk '{print $NF}' | tr -d '"')


## Cluster parameter
echo -n '
variable "static-db-cluster-params" {
  description = "List of static paramaters"
  default = ' >>$file

aws rds describe-engine-default-cluster-parameters \
--db-parameter-group-family $family \
--output json \
--query 'EngineDefaults.Parameters[?(ApplyType==`static` && IsModifiable==`true`)].ParameterName' \
>>$file

echo '}' >>$file


## DB parameter
echo -n '
variable "static-db-params" {
  description = "List of static paramaters"
  default = ' >$file

aws rds describe-engine-default-parameters \
--db-parameter-group-family $family \
--output json \
--query 'EngineDefaults.Parameters[?(ApplyType==`static` && IsModifiable==`true`)].ParameterName' \
>>$file

echo '}' >>$file


terraform fmt
