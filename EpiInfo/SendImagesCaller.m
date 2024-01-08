//
//  SendImagesCaller.m
//  EpiInfo
//
//  Created by John Copeland on 1/4/24.
//

#import "SendImagesCaller.h"

@implementation SendImagesCaller
- (void)callSendImages:(UIButton *)sender
{
    spanishLanguage = [(NSNumber *)[sender.layer valueForKey:@"spanishLanguage"] boolValue];
    ls = [NSMutableArray arrayWithArray:(NSArray *)[sender.layer valueForKey:@"ls"]];
    paths0 = (NSString *)[sender.layer valueForKey:@"paths0"];
    formName = (NSString *)[sender.layer valueForKey:@"formName"];
    rootViewController = (UIViewController *)[sender.layer valueForKey:@"rootViewController"];
    if (![MFMailComposeViewController canSendMail])
    {
        UIAlertController *alertM = [UIAlertController alertControllerWithTitle:@"" message:@"The native iOS Mail app must be configured to use this feature. Use Settings, Mail, Accounts, to add a mail account." preferredStyle:UIAlertControllerStyleAlert];
        if (spanishLanguage)
            [alertM setMessage:@"La aplicación de correo nativa de iOS debe estar configurada para utilizar esta función. Utilice Configuración, Correo, Cuentas para agregar una cuenta de correo."];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
        [alertM addAction:okAction];
        [rootViewController presentViewController:alertM animated:YES completion:nil];
        return;
    }
    UIAlertController *alertI = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"This dataset has %lu associated image files. They will be sent as attachments to multiple emails with a maximum of 10 per email.", (unsigned long)[ls count]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"Send All" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self emailAllImageFiles];
    }];
    UIAlertAction *newAction = [UIAlertAction actionWithTitle:@"Send Only Unsent" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self emailNewImageFiles];
    }];
    if (spanishLanguage)
    {alertI = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"Este conjunto de datos contiene %lu archivos de imágenes. Se enviarán como archivos adjuntos en varios correos electrónicos con un máximo de 10 por correo electrónico.", (unsigned long)[ls count]] preferredStyle:UIAlertControllerStyleAlert];
        cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
        allAction = [UIAlertAction actionWithTitle:@"Enviar todos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self emailAllImageFiles];
        }];
        newAction = [UIAlertAction actionWithTitle:@"Enviar solo archivos que no han sido enviados" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self emailNewImageFiles];
        }];
    }
    [alertI addAction:allAction];
    [alertI addAction:newAction];
    [alertI addAction:cancelAction];
    [rootViewController presentViewController:alertI animated:YES completion:nil];
}

- (void)emailAllImageFiles
{
    NSError *deleteError;
    BOOL rv = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/EpiInfoDatabase/ImageRepository/%@.txt", paths0, formName]])
    {
        rv = [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/EpiInfoDatabase/ImageRepository/%@.txt", paths0, formName] error:&deleteError];
    }
    if (rv)
    {
        [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/EpiInfoDatabase/ImageRepository/%@.txt", paths0, formName] contents:[@"ImageFileNames" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    [self emailImageFiles];
}

- (void)emailNewImageFiles
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/EpiInfoDatabase/ImageRepository/%@.txt", paths0, formName]])
    {
        NSString *sentImagesString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/EpiInfoDatabase/ImageRepository/%@.txt", paths0, formName] encoding:NSUTF8StringEncoding error:nil];
        NSArray *sentImagesArray = [sentImagesString componentsSeparatedByString:@",\n"];
        [ls removeObjectsInArray:sentImagesArray];
    }
    else
    {
        [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/EpiInfoDatabase/ImageRepository/%@.txt", paths0, formName] contents:[@"ImageFileNames" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    [self emailImageFiles];
}

- (void)emailImageFiles
{
    sentImages = [[NSMutableArray alloc] init];
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    int imagesattached = 0;
    while ([ls count] > 0)
    {
        id file = [ls objectAtIndex:0];
        [ls removeObjectAtIndex:0];
        [composer addAttachmentData:[NSData dataWithContentsOfFile:[[[paths0 stringByAppendingString:@"/EpiInfoDatabase/ImageRepository/"] stringByAppendingString:formName] stringByAppendingString:[NSString stringWithFormat:@"/%@", file]]] mimeType:@"image/jpeg" fileName:(NSString *)file];
        [sentImages addObject:file];
        imagesattached++;
        if (imagesattached > 9)
            break;
    }
    [composer setSubject:@"Epi Info Images"];
    [composer setMessageBody:@"Here are some Epi Info image files." isHTML:NO];
    if (imagesattached > 0)
        [rootViewController presentViewController:composer animated:YES completion:^(void){
        }];
    else
    {
        UIAlertController *alertI = [UIAlertController alertControllerWithTitle:@"" message:@"All image files have been sent." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
        if (spanishLanguage)
            alertI = [UIAlertController alertControllerWithTitle:@"" message:@"Todos las imágenes han sido enviadas." preferredStyle:UIAlertControllerStyleAlert];
        [alertI addAction:okAction];
        [rootViewController presentViewController:alertI animated:YES completion:nil];
    }
}

// <MFMailComposeViewControllerDelegate> delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            //            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [rootViewController dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent)
        {
            NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:[NSString stringWithFormat:@"%@/EpiInfoDatabase/ImageRepository/%@.txt", self->paths0, self->formName]];
            for (id file in self->sentImages)
            {
                [fileHandler seekToEndOfFile];
                [fileHandler writeData:[[NSString stringWithFormat:@",\n%@", file] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            [self emailImageFiles];
        }
        else
            NSLog(@"Dismissed after not sending");
    }];
}
@end
