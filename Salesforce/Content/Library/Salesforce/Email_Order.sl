namespace: Salesforce
flow:
  name: Email_Order
  inputs:
    - user: daniel@rpamf.onmicrosoft.com
    - sf_username: ron.sercely-macb@force.com
    - sf_password: '2wsx#EDC'
  workflow:
    - Get_Authorization_Token:
        do_external:
          18ff19e5-8484-4803-857e-4a2293b91eef:
            - loginAuthority: 'https://login.windows.net/rpamf.onmicrosoft.com/oauth2/token'
            - clientId: 4c800826-f5c8-44a1-b779-2f333099823d
            - clientSecret:
                value: 'JHAH]Yqe3*97FA0kb+]lO0X5][5iNw_]'
                sensitive: true
        publish:
          - authToken
        navigate:
          - success: List_Messages
          - failure: on_failure
    - List_Messages:
        do_external:
          90083ffe-8000-4ddf-b158-22898a5efdfa:
            - authToken: '${authToken}'
            - userPrincipalName: '${user}'
            - folderId: Inbox
            - topQuery: '1'
        publish:
          - message_json: '${document}'
        navigate:
          - success: get_message_id
          - failure: on_failure
    - get_message_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${message_json}'
            - json_path: '$.value[0].id'
        publish:
          - messageId: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: List_Attachments_1
          - FAILURE: on_failure
    - Get_Attachment:
        do_external:
          a5971b46-89e1-4f5a-bef8-ceca822b377f:
            - authToken: '${authToken}'
            - userPrincipalName: '${user}'
            - messageId: '${messageId}'
            - attachmentId: '${attachmentId}'
            - filePath: "c:\\temp"
        publish:
          - attachment_json: '${document}'
        navigate:
          - success: get_file_name
          - failure: on_failure
    - get_file_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${attachment_json}'
            - json_path: $.name
        publish:
          - file_name: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: extract_text_from_pdf
          - FAILURE: on_failure
    - extract_text_from_pdf:
        do:
          io.cloudslang.tesseract.ocr.extract_text_from_pdf:
            - file_path: "${'c:\\\\temp\\\\' + file_name}"
            - data_path: "c:\\temp\\tessdata\\tessdata"
            - language: ENG
        publish:
          - text_string
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - List_Attachments_1:
        do_external:
          40f50977-0b1c-4a43-bc37-6453f9a01a36:
            - authToken: '${authToken}'
            - userPrincipalName: '${user}'
            - messageId: '${messageId}'
        publish:
          - attachmentId
        navigate:
          - success: Get_Attachment
          - failure: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Get_Authorization_Token:
        x: 94
        'y': 151
      List_Messages:
        x: 102
        'y': 358
      get_message_id:
        x: 238
        'y': 172
      Get_Attachment:
        x: 444
        'y': 164
      get_file_name:
        x: 438
        'y': 353
      extract_text_from_pdf:
        x: 621
        'y': 240
        navigate:
          9fdb412d-7d7b-5321-26fe-b8acdae2151c:
            targetId: 2c418798-a4ff-8706-7335-83431a99f8ca
            port: SUCCESS
      List_Attachments_1:
        x: 243
        'y': 343
    results:
      SUCCESS:
        2c418798-a4ff-8706-7335-83431a99f8ca:
          x: 630
          'y': 382
