#!/usr/local/opt/php@7.4/bin/php
<?php

const EXPORT_FILE = 'inventory.json';

const TAGS_TO_GROUPS = [
    'reddit-db'  => 'db',
    'reddit-app' => 'app',
];

const GROUP_OF_UNKNOWN = 'unknown';

$isVerbose = false;
$hasFlag = false;
foreach ($argv as $arg) {
    switch ($arg) {
        case '-v':
            $isVerbose = true;
            break;
        case '--list':
            $hasFlag = true;
            break;
    }
}

$header = static function (string $message) use ($isVerbose): void {
    if (!$isVerbose) {
        return;
    }
    printf("== %s ==\n", $message);
};

$exportResult = static function (array $instances) use ($header): void {
    $header("Exporting result");
    file_put_contents(EXPORT_FILE, json_encode($instances, JSON_THROW_ON_ERROR));
};

$error = static function (string $message, bool $interrupt = true) use ($exportResult, $isVerbose): void {
    if ($isVerbose) {
        printf("Error: %s\n", $message);
    }
    if ($interrupt) {
        $exportResult([]);
        exit(1);
    }
};

if (!$hasFlag) {
    $error("Flag --list is required");
}

$header('Fetching YC instances');
$instanceData = shell_exec('yc compute instance list --format json') ?: null;
if ($instanceData === null) {
    $error('Cannot retrieve instance information');
}
$decoded = [];
try {
    $header('Decoding data');
    $decoded = json_decode($instanceData, true, 512, JSON_THROW_ON_ERROR);
} catch (JsonException $e) {
    $error('Cannot decode data from YC');
}

$instances = [];
$header("Building instance tree");
foreach ($decoded as $idx => $instance) {
    $name = $instance['name'] ?? sprintf('%s-%d', 'instance', $idx);
    $ip   = $instance['network_interfaces'][0]['primary_v4_address']['one_to_one_nat']['address'] ?? null;

    if ($ip === null) {
        $error(sprintf('Cannot retrieve ip of instance "%s"', $name), false);
        continue;
    }

    $tag   = $instance['labels']['tags'] ?? null;
    $group = TAGS_TO_GROUPS[$tag] ?? GROUP_OF_UNKNOWN;

    $instances[$group]['hosts'][$name] = ['ansible_host' => $ip];
}

$exportResult($instances);
$header("Successfully done");
try {
    echo json_encode($instances, JSON_THROW_ON_ERROR);
} catch (JsonException $e) {
    $error('Cannot encode result json');
}
