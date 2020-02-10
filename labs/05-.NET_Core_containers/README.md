# .NET Core containers

## Prerequisites

Install the [.NET Core 3.1 SDK](https://dotnet.microsoft.com/download)

If you have .NET Core installed, use the `dotnet --info` command to determine which SDK you're using.

## Test the app

In the **app** folder, we have already provided a simple .NET Core console application.

To test the app type:

```console
$ dotnet run --project app
Counter: 1
Counter: 2
Counter: 3
Counter: 4
Counter: 5
...
```
The application runs indefinitely and counts numbers every second. To exit from the app use the cancel command CTRL+C.

## Publish the app

```console
$ dotnet publish -c Release app
Microsoft (R) Build Engine version 16.4.0+e901037fe for .NET Core
Copyright (C) Microsoft Corporation. All rights reserved.

  Restore completed in 26.58 ms for .../ITS-ICT_Containers/labs/05-.NET_Core_containers/app/myapp.csproj.
  myapp -> .../ITS-ICT_Containers/labs/05-.NET_Core_containers/app/bin/Release/netcoreapp3.1/myapp.dll
  myapp -> .../ITS-ICT_Containers/labs/05-.NET_Core_containers/app/bin/Release/netcoreapp3.1/publish/
```

## Build the image

Let's build a .NET Core-based image with your application packed within.

```console
$ docker build -t net-image:1.0 -f Dockerfile .
Sending build context to Docker daemon  654.3kB
Step 1/3 : FROM mcr.microsoft.com/dotnet/core/runtime:3.1
3.1: Pulling from dotnet/core/runtime
bc51dd8edc1b: Pull complete 
6848f14cfbf7: Pull complete c
01ae9269f21a: Pull complete 
e5a46ebecd63: Pull complete 
Digest: sha256:1a314313bbfc550897fb760dc05c816f42e7f911c8bb8a4c9b5bde3cdad6ac76
Status: Downloaded newer image for mcr.microsoft.com/dotnet/core/runtime:3.1
 ---> abe903e47cb5
Step 2/3 : COPY app/bin/Release/netcoreapp3.1/publish/ app/
 ---> a332a6bc63d4
Step 3/3 : ENTRYPOINT ["dotnet", "app/myapp.dll"]
 ---> Running in f6197afca097
Removing intermediate container f6197afca097
 ---> 9ea6d00a1843
Successfully built 9ea6d00a1843
Successfully tagged net-image:1.0
```

Check the involved images 

```console
$ docker images | grep net
net-image                                                               1.0                        9ea6d00a1843        7 minutes ago       190MB
mcr.microsoft.com/dotnet/core/runtime                                   3.1                        abe903e47cb5        7 days ago          190MB
```

Run a container from your image

```console
$ docker run  net-image:1.0
Counter: 1
Counter: 2
Counter: 3
Counter: 4
Counter: 5
Counter: 6
...
```

To exit from the container use the cancel command CTRL+C.