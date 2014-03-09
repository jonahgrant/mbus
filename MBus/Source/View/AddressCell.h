//
//  AddressCell.h
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@class AddressCellModel;

@interface AddressCell : UITableViewCell

@property (strong, nonatomic) AddressCellModel *model;

- (void)purgeMapMemory;

@end
