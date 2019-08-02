namespace: FinishedFlow
flow:
  name: FromPetr
  workflow:
    - create_multiple_orders:
        do:
          Salesforce.sub_flows.create_multiple_orders: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - create_order:
        do:
          Salesforce.sub_flows.create_order: []
        navigate:
          - FAILURE: on_failure
    - get_order:
        do:
          Salesforce.sub_flows.get_order: []
        navigate: []
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_multiple_orders:
        x: 261
        'y': 173
        navigate:
          68c008f1-8b72-d1e3-d5e1-36c9f345fd7a:
            targetId: 9e24c8e8-bf89-3a78-0e8b-08ac4d06e0fe
            port: SUCCESS
      create_order:
        x: 456
        'y': 326
      get_order:
        x: 689
        'y': 367
    results:
      SUCCESS:
        9e24c8e8-bf89-3a78-0e8b-08ac4d06e0fe:
          x: 660
          'y': 126
