<p>&nbsp;</p>
<p align="center">
<img src="https://cyb.ai/large-green.28aa247dfc.png" width=100>
</p>

<p align="center">
An instant, zero-config bostrom blockchain.
</p>

<br/>

## What is localbostrom?

Localbostrom is a complete bostrom testnet containerized with Docker and orchestrated with a simple `docker-compose` file. It simplifies the way smart-contract developers test their contracts in a sandbox before they deploy them on a testnet or mainnet.

Localbostrom comes preconfigured with opinionated, sensible defaults for standard testing environments. It also comes with pre-configured [cyberindex](https://github.com/cybercongress/cyberindex) to allow fast and easy data manipulation and analysis.

Localbostrom has the following advantages over a public testnet:

- Quick to reset for rapid iterations
- Simple simulations of different scenarios
- Controllable validator behavior

## Prerequisites

- [Docker](https://www.docker.com/)
- [`docker-compose`](https://github.com/docker/compose)
- Supported known architecture: x86_64
- 8+ GB of RAM is recommended

## Get localbostrom

1. Run the following commands::

```sh
$ git clone https://github.com/SaveTheAles/localbostrom
$ cd localbostrom
```

## Start, stop, and reset

- Start localbostrom with cyberindex:

```sh
$ docker-compose up --detach
```

Your environment now contains:

- [cyber](https://github.com/cybercongress/go-cyber) RPC node running on `http://localhost:26657`
- GRPC endpoint at `http://localhost:9090`
- LCD running on `http://localhost:1317` with swagger at `http://localhost:1317/swagger`
- [GraphQL](https://hasura.io/docs/latest/graphql/core/index/) endpoint on `http://localhost:8090`

- Start only localbostrom:

```sh
$ docker-compose up -d cyber --detach
```

- Stop localbostrom:

```sh
$ docker-compose stop
```

- Reset the state:

```sh
$ docker-compose rm
```

### cyber

1. Ensure the same version of `cyber` daemon and localbostrom are installed.

2. Use `cyber` to talk to your localbostrom `cyber` node:

```sh
$ cyber status
```

This command automatically works because `cyber` connects to `localhost:26657` by default

The following command is the explicit form:
```sh
$ cyber status --node=http://localhost:26657
```

3. Run any of the `cyber` commands against your localbostrom network, as shown in the following example:

```sh
$ cyber query account bostrom1phaxpevm5wecex2jyaqty2a4v02qj7qm5n94ug
```

4. If you want to hard restart the network (drop state and start from the genesis) you can use `hard_restart.sh` script

```sh
./hard_restart.sh
```

### Cyber SDK for Python

Connect to the chain through localbostrom's LCD server:

```python
from cyber_sdk.client.lcd import LCDClient
cyber = LCDClient("localbostrom", "http://localhost:1317")
```

## Configure localbostrom

The majority of localbostrom is implemented through a `docker-compose.yml` file, making it easily customizable. You can use localbostrom as a starting template point for setting up your own local Terra testnet with Docker containers.

Out of the box, localbostrom comes preconfigured with opinionated settings such as:

- ports defined for RPC (26657), LCD (1317) and FCD (3060)
- standard [accounts](#accounts)
- index [config](./cyberindex/config.yaml)(postgress db params, hasura access params etc.)

### Modifying node configuration

You can modify the node configuration of your validator in the `config/config.toml` and `config/app.toml` files.

#### Pro tip: Speed Up Block Time

localbostrom is often used alongside a script written with Terra.js SDK or Terra Python SDK as a convenient way to do integration tests. You can greatly improve the experience by speeding up the block time.

To increase block time, edit the `[consensus]` parameters in the `config/config.toml` file, and specify your own values.

### Modifying cyberindex configuration

To modify cyberindex params - edit [config](./cyberindex/config.yaml), posgtres params could be altered in `docker-compose.yml`. Changing postgres params require container and `./cyberindex/postgres` folder termination and rebuild with:

```sh
docker-compose down postgres
rm -rf cyberindex/postgres
edit what you need in `cyberindex/config.yaml`
docker-compose up -d postgres --detach
```

### Modifying genesis

TODO

## Accounts

localbostrom is pre-configured with one validator and 10 accounts with boot balances.

| Account   | Address                                                                                                  | Mnemonic                                                                                                                                                                   |
| --------- | -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| validator | `bostrom1phaxpevm5wecex2jyaqty2a4v02qj7qm5n94ug`<br/>`bostromvaloper1phaxpevm5wecex2jyaqty2a4v02qj7qmvfz2vt` | `satisfy adjust timber high purchase tuition stool faith fine install that you unaware feed domain license impose boss human eager hat rent enjoy dawn`                    |
| test1     | `bostrom1cyyzpxplxdzkeea7kwsydadg87357qnau43779`                                                           | `notice oak worry limit wrap speak medal online prefer cluster roof addict wrist behave treat actual wasp year salad speed social layer crew genius`                       |
| test2     | `bostrom18s5lynnmx37hq4wlrw9gdn68sg2uxp5rr7deye`                                                           | `quality vacuum heart guard buzz spike sight swarm shove special gym robust assume sudden deposit grid alcohol choice devote leader tilt noodle tide penalty`              |
| test3     | `bostrom1qwexv7c6sm95lwhzn9027vyu2ccneaqaxafy7g`                                                           | `symbol force gallery make bulk round subway violin worry mixture penalty kingdom boring survey tool fringe patrol sausage hard admit remember broken alien absorb`        |
| test4     | `bostrom14hcxlnwlqtq75ttaxf674vk6mafspg8x9q5suy`                                                           | `bounce success option birth apple portion aunt rural episode solution hockey pencil lend session cause hedgehog slender journey system canvas decorate razor catch empty` |
| test5     | `bostrom12rr534cer5c0vj53eq4y32lcwguyy7nnxrglz7`                                                           | `second render cat sing soup reward cluster island bench diet lumber grocery repeat balcony perfect diesel stumble piano distance caught occur example ozone loyal`        |
| test6     | `bostrom1nt33cjd5auzh36syym6azgc8tve0jlvk5m8a64`                                                           | `spatial forest elevator battle also spoon fun skirt flight initial nasty transfer glory palm drama gossip remove fan joke shove label dune debate quick`                  |
| test7     | `bostrom10qfrpash5g2vk3hppvu45x0g860czur8zpn8w6`                                                           | `noble width taxi input there patrol clown public spell aunt wish punch moment will misery eight excess arena pen turtle minimum grain vague inmate`                       |
| test8     | `bostrom1f4tvsdukfwh6s9swrc24gkuz23tp8pd3jdyhpg`                                                           | `cream sport mango believe inhale text fish rely elegant below earth april wall rug ritual blossom cherry detail length blind digital proof identify ride`                 |
| test9     | `bostrom1myv43sqgnj5sm4zl98ftl45af9cfzk7nu6p3gz`                                                           | `index light average senior silent limit usual local involve delay update rack cause inmate wall render magnet common feature laundry exact casual resource hundred`       |
| test10    | `bostrom14gs9zqh8m49yy9kscjqu9h72exyf295azqa4qr`                                                           | `prefer forget visit mistake mixture feel eyebrow autumn shop pair address airport diesel street pass vague innocent poem method awful require hurry unhappy shoulder`     |

## Whole setup architecture

```sh
.
├── bostrom_config          `folder wich typically is .cyber/config, containd all node configs and params`
│   ├── addrbook.json
│   ├── app.toml
│   ├── client.toml
│   ├── config.toml
│   ├── genesis.json
│   ├── node_key.json
│   └── priv_validator_key.json
├── cyberindex               `folder containing everything relayted to cyberindex`
│   ├── config.yaml          `cyberindex config`
│   ├── postgres             `folder contains postgress db`
│   └── schema               `folder with sql views for db, add yours here to be initiated during postgres startup`
│       ├── 00-cosmos.sql
│       ├── 01-auth.sql
│       ├── 02-bank.sql
│       ├── 03-modules.sql
│       ├── 04-graph.sql
│       ├── 05-grid.sql
│       ├── 06-resources.sql
│       └── 07-wasm.sql
├── data                      `contain all chain data`
│   └── priv_validator_state.json
├── docker-compose.yml
├── hard_restart.sh
└── README.md
```
