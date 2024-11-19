module Git.Remote.TcpClient (
	withConnection,
	send,
	receiveWithSideband,
	receiveFully,
	receive
) where

import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString as B
import Network.Socket hiding                    (recv, send)
import Network.Socket.ByteString                (recv, sendAll)
import Data.Monoid                              (mempty, mappend)
import Numeric                                  (readHex)

withConnection :: HostName -> ServiceName -> (Socket -> IO b) -> IO b
withConnection :: host port consumer do
	sock <- openConnection host port
	r <- consumer sock
	sClose sock
	return r

send :: Socket -> String -> IO ()
send sock msg = sendAll sock $ C.pack msg

