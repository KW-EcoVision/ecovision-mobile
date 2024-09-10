import torch
import torch.nn as nn
from einops import rearrange, repeat
from einops.layers.torch import Rearrange
from torch.nn import functional as F
from collections import OrderedDict
'''
predefine param : 이래야 덜 헷갈림 
'''
#input param
IMG_SIZE = 448
IMG_DEPTH = 3
BATCH_SIZE = 1
#model param
PATCH_SIZE = 128
PATCH_SEQUENCE = (IMG_SIZE//PATCH_SIZE)**2+1
EMBEDING_DEPTH = 512
ENCODER_NUM = 8
GRID_CELL_SIZE = 7

class patch_embedding(nn.Module):
    def __init__(self):
        super(patch_embedding,self).__init__()
        self.patch = nn.Conv2d(
            in_channels=IMG_DEPTH,
            out_channels=EMBEDING_DEPTH,
            kernel_size=(PATCH_SIZE,PATCH_SIZE),
            stride=(PATCH_SIZE,PATCH_SIZE),
            padding=0
        )
        self.embeding_layer = nn.Sequential(
            self.patch,
            Rearrange('b d w h -> b (w h) d',w=IMG_SIZE//PATCH_SIZE,h=IMG_SIZE//PATCH_SIZE,d=EMBEDING_DEPTH)
        )
        self.cls_tocken = nn.Parameter(torch.randn((1,EMBEDING_DEPTH)))
        self.position_tocken = nn.Parameter(torch.randn((PATCH_SEQUENCE,EMBEDING_DEPTH)))
    def forward(self,tensor):
        cls_token = repeat(self.cls_tocken.unsqueeze(0),'() c d -> b c d',b=tensor.shape[0])
        position_token = repeat(self.position_tocken.unsqueeze(0),'() w h -> b w h',b= tensor.shape[0])
        tensor = self.embeding_layer(tensor)
        tensor = torch.cat([tensor,cls_token],dim=1)
        tensor += position_token
        return tensor

class MLP(nn.Module):
    def __init__(self):
        super(MLP,self).__init__()
        self.perceptrone = nn.Sequential(
            nn.LayerNorm(normalized_shape=(EMBEDING_DEPTH,)),
            nn.Linear(in_features=EMBEDING_DEPTH,out_features=EMBEDING_DEPTH*2),
            nn.Linear(in_features=EMBEDING_DEPTH*2, out_features=EMBEDING_DEPTH),
            nn.GELU()
        )
    def forward(self,tensor):
        residual = tensor
        tensor = self.perceptrone(tensor)
        tensor += residual
        return tensor

class Encoder(nn.Module):
    def __init__(self):
        super(Encoder,self).__init__()
        self.mlp = MLP()
        self.mht = nn.MultiheadAttention(embed_dim=EMBEDING_DEPTH,num_heads=8,dropout=0.5)
    def forward(self,tensor):
        tensor = F.layer_norm(tensor,(EMBEDING_DEPTH,))
        out,_ = self.mht(tensor,tensor,tensor)
        tensor = out + tensor
        tensor = self.mlp(tensor)
        return tensor

class MLP_HEAD(nn.Module):
    def __init__(self):
        super(MLP_HEAD,self).__init__()
        self.l = nn.Sequential(
            nn.Linear(in_features=5120,out_features=2940*2),
            nn.Linear(in_features=2940*2,out_features=2940)
        )
        self.final_layer = nn.Linear(in_features=2940,out_features=(GRID_CELL_SIZE*GRID_CELL_SIZE*30))
    def forward(self,tensor):
        tensor = rearrange(tensor,'b l e -> b (l e)',b = tensor.shape[0])
        tensor = self.l(tensor)
        tensor = self.final_layer(tensor)
        return rearrange(
            tensor,
            pattern='b (g1 g2 d) -> b g1 g2 d',
            b = tensor.shape[0],
            g1 = GRID_CELL_SIZE,
            g2 = GRID_CELL_SIZE,
            d = 30)

class VIT(nn.Module):
    def __init__(self):
        super(VIT,self).__init__()

        self.head = nn.Sequential(OrderedDict([
            ('patch_embedding', patch_embedding())
        ]))

        self.encoder = nn.Sequential(OrderedDict([
            (f'encoder_{i + 1}', Encoder()) for i in range(ENCODER_NUM)
        ]))

        self.mlp_head = nn.Sequential(OrderedDict([
            ('mlp_head', MLP_HEAD())
        ]))

    def forward(self,tensor):

        tensor = self.head(tensor)

        tensor = self.encoder(tensor)

        tensor = self.mlp_head(tensor)

        return tensor


if __name__ == "__main__":
    dummy = torch.randn(size=(BATCH_SIZE,3,448,448)).to('cuda')
    model = VIT().to('cuda')
    pred = model(dummy)
    print(pred.shape)