data Remote = Remote {
	getHost :: String,
	getPort :: Maybe int,
	getRepository :: String
} deriving (Eq, Show)

lsRemote' :: Remote -> IO [PacketLine]
lsRemote' Remote{..} = withSocketDo $
	withConnection getHost (show $ fromMaybe 9418 getPort) $ \sock -> do
		let payload = gitProtocolRequest getHost getRepository
		send sock payload
		response <- receive sock
		send sock flushPkt -- Tell the server to disconnect
		return $ parsePacket % L.fromChunks [response]
