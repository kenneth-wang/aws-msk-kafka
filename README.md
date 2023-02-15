# An example for deploying AWS MSK (Kafka) with Cloudformation

## Deploying Kafka with AWS MSK

1. Create a key pair which will be used to ssh into the AWS MSK client instance. In this case I have named the key pair as `key-pair`

2. Make the following changes in `./infrastructure/deploy_kafka.sh` with the name of the new key pair created earlier.
   - Replace the `KEY_NAME` with the name of the new key pair created earlier.
   - Replace the `AWS` variable with `"aws --profile <profile name>"` if you need to run the AWS commands on your command line with a profile.

3. Deploy Kafka stack with the cloudformation stack

    ```sh
    ./infrastructure/deploy_kafka.sh
    ```

4. SSH into AWS MSK client instance

    ```sh
    ssh -i key-pair.pem -o PubkeyAcceptedKeyTypes=+ssh-rsa ec2-user@<client machine dns>
    ```

5. Download Apache Kafka

    ```sh
    wget https://archive.apache.org/dist/kafka/2.2.1/kafka_2.12-2.2.1.tgz

    tar -xzf kafka_2.12-2.2.1.tgz
    ```

6. Go to the `kafka_2.12-2.2.1/bin` directory. Copy the following property settings and paste them into a new file. Name the file as `client.properties`.

    ```sh
    security.protocol=SSL
    ```

7. Open the [Amazon MSK console](https://console.aws.amazon.com/msk/). Go to the cluster and click on `"View client information"`.

8. Copy the connection string for the private endpoint. You will get three endpoints for each of the brokers. Replace `BootstrapServerString` with the broker endpoints.

    ```sh
    <path-to-your-kafka-installation>/bin/kafka-topics.sh --create --bootstrap-server BootstrapServerString --command-config <path-to-your-kafka-installation>/bin/client.properties --replication-factor 3 --partitions 1 --topic <topic name>
    ```

9. Run the following command to start a console producer. Replace `BootstrapServerString` with the three endpoints for each of the brokers.

    ```sh
    <path-to-your-kafka-installation>/bin/kafka-console-producer.sh --broker-list BootstrapServerString --producer.config <path-to-your-kafka-installation>/bin/client.properties --topic <topic name>
    ```

10. Enter any message that you want, and press Enter. Repeat this step two or three times. Every time you enter a line and press Enter, that line is sent to your Apache Kafka cluster as a separate message.

11. Open a second, separate connection to the client machine in a new window. Key in the following command. Replace `BootstrapServerString` with the three endpoints for each of the brokers. You should start seeing the messages you entered earlier when you used the console producer command.

    ```sh
    <path-to-your-kafka-installation>/bin/kafka-console-consumer.sh --bootstrap-server BootstrapServerString --consumer.config <path-to-your-kafka-installation>/bin/client.properties --topic <topic name> --from-beginning
    ```

## Teardown required

1. Delete Kafka stack
2. Remove `key-pair` key pair

## References

- https://catalog.us-east-1.prod.workshops.aws/workshops/c86bd131-f6bf-4e8f-b798-58fd450d3c44/en-US/setup
- https://spark.apache.org/docs/latest/structured-streaming-kafka-integration.html
- https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-msk-cluster.html
- https://www.youtube.com/watch?v=5WaIgJwYpS8
- https://docs.aws.amazon.com/msk/latest/developerguide/getting-started.html
- https://stackoverflow.com/questions/41964676/kafka-connect-running-out-of-heap-space
- https://www.tutorialsbuddy.com/send-data-to-amazon-msk-topic-from-aws-lambda-python-example
- https://www.youtube.com/watch?v=OXeXLhlCa4o
- https://www.confluent.io/blog/serverless-kafka-streaming-with-confluent-cloud-and-aws-lambda/
- https://aws.amazon.com/blogs/compute/using-aws-lambda-for-streaming-analytics/