from pprint import pprint
import boto3
from botocore.exceptions import ClientError

def get_serie(title, series_id):
    ydb_docapi_client = boto3.resource('dynamodb', endpoint_url = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g17gj9ehpe2oil8ptg/etnesogluddil9g3h32i")

    table = ydb_docapi_client.Table('docapitest/series')

    try:
        response = table.get_item(Key = {'series_id': series_id, 'title': title})
    except ClientError as e:
        print(e.response['Error']['Message'])
    else:
        return response['Item']

if __name__ == '__main__':
    serie = get_serie("Supernatural", 3,)
    if serie:
        print("Record read:")
        pprint(serie, sort_dicts = False)